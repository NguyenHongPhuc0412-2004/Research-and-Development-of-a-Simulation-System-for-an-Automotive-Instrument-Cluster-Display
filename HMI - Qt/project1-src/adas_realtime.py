#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ADAS Realtime - Yocto version (OpenCV DNN, KHONG dung ultralytics/ncnn)
========================================================================
Engine: cv2.dnn.readNetFromONNX() doc thang yolov8s.onnx
Ly do: opencv + python3-opencv da co san trong local.conf -> KHONG can them
       package/layer nao tren Yocto. Build lai image la chay.

>>> Deploy:
       /opt/adas/adas_realtime.py     <- file nay
       /opt/adas/yolov8s.onnx         <- model export tu PC voi opset=12

Giao tiep voi Qt/QML qua 3 file /tmp/ (giu nguyen, khong doi):
  /tmp/adas_ready      - flag: Python da san sang
  /tmp/adas_live.jpg   - frame moi nhat (atomic write)
  /tmp/adas_stats.json - { video_fps, ai_fps, obj_count, objects, ts }

Cau truc model (da xac nhan tu file ncnn + lenh export ultralytics):
  Input:  (1, 3, 192, 192) float32, range 0-1, RGB
  Output: (1, 84, 756) - 1 batch, 4 box+80 class, 756 anchors (576+144+36)
  Format: [cx, cy, w, h, score_class0..score_class79] da o pixel space 192x192
  Anchors + strides + DFL da bake san trong network -> khong can decode lai
"""

import os
import sys
import json
import time
import signal
import functools
from threading import Thread, Lock

import cv2
import numpy as np

# stdout khong phai TTY (chay duoi QProcess) -> flush thu cong
print = functools.partial(print, flush=True)

# ===================== DUONG DAN =====================
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ONNX_PATH  = os.path.join(SCRIPT_DIR, "yolov5s.onnx")

# 3 file IPC - PHAI khop chinh xac voi adasprocesshandler.cpp
READY_FLAG = "/tmp/adas_ready"
FRAME_PATH = "/tmp/adas_live.jpg"
STATS_PATH = "/tmp/adas_stats.json"
FRAME_TMP  = "/tmp/.adas_live_tmp.jpg"
STATS_TMP  = "/tmp/.adas_stats_tmp.json"

# ===================== CONFIG MODEL =====================
IMGSZ        = 192    # phai khop voi luc export (yolo export ... imgsz=192)
NUM_CLASSES  = 80     # COCO
OPENCV_THREADS = 4    # RPi4 = 4 core

# ===================== CONFIG CAMERA =====================
CAMERA_INDEX  = 0
CAMERA_WIDTH  = 320
CAMERA_HEIGHT = 240
CAMERA_FPS    = 30

# ===================== NGUONG DETECTION =====================
CONF_THRESH = 0.4
IOU_THRESH  = 0.4
MAX_DET     = 8

# Tan suat ghi file ra /tmp cho Qt (C++ poll 10Hz -> 20Hz du muot)
WRITE_INTERVAL = 1.0 / 20.0
JPEG_QUALITY   = 80

# ===================== CLASS / MAU =====================
ADAS_CLASSES = [0, 1, 2, 3, 5, 7, 9, 11]
VIET_NAMES = {
    0: "Nguoi", 1: "Xe dap", 2: "Oto", 3: "Xe may",
    5: "Xe bus", 7: "Xe tai", 9: "Den GT", 11: "Bien Stop"
}
COLOR_MAP = {
    0: (255, 100, 0),
    1: (0, 0, 255), 2: (0, 0, 255), 3: (0, 0, 255),
    5: (0, 0, 255), 7: (0, 0, 255),
    9: (0, 255, 255), 11: (0, 255, 255)
}

# ===================== STATE DUNG CHUNG =====================
latest_frame = None
latest_boxes = []
box_age = 0
frame_lock  = Lock()
result_lock = Lock()
running = True
inf_times = []
_shape_printed = False


# ===================== SIGNAL HANDLER =====================
def _handle_signal(signum, frame):
    global running
    print(f"[ADAS] Nhan signal {signum}, dang dung...")
    running = False

signal.signal(signal.SIGTERM, _handle_signal)
signal.signal(signal.SIGINT,  _handle_signal)


# ===================== ATOMIC WRITE HELPERS =====================
def write_frame_atomic(frame):
    ok, buf = cv2.imencode(".jpg", frame, [cv2.IMWRITE_JPEG_QUALITY, JPEG_QUALITY])
    if not ok:
        return
    with open(FRAME_TMP, "wb") as f:
        f.write(buf.tobytes())
    os.replace(FRAME_TMP, FRAME_PATH)


def write_stats_atomic(video_fps, ai_fps, obj_count, objects):
    stats = {
        "video_fps": round(float(video_fps), 1),
        "ai_fps":    round(float(ai_fps), 2),
        "obj_count": int(obj_count),
        "objects":   objects,
        "ts":        time.time(),
    }
    with open(STATS_TMP, "w") as f:
        json.dump(stats, f)
    os.replace(STATS_TMP, STATS_PATH)


def cleanup():
    print("[ADAS] Cleanup...")
    try:
        cap.release()
    except Exception:
        pass
    for p in (READY_FLAG, FRAME_PATH, STATS_PATH, FRAME_TMP, STATS_TMP):
        try:
            os.remove(p)
        except OSError:
            pass
    print("[ADAS] Done!")


# ===================== LETTERBOX =====================
def letterbox(img, new_size):
    """Resize giu ti le + pad mau xam 114. Tra ve (canvas, ratio, dx, dy).
    Voi camera 320x240 -> letterbox 192x192: ratio=0.6, dx=0, dy=24."""
    h, w = img.shape[:2]
    r = min(new_size / h, new_size / w)
    nh, nw = int(round(h * r)), int(round(w * r))
    resized = cv2.resize(img, (nw, nh), interpolation=cv2.INTER_LINEAR)
    canvas = np.full((new_size, new_size, 3), 114, dtype=np.uint8)
    dx = (new_size - nw) // 2
    dy = (new_size - nh) // 2
    canvas[dy:dy + nh, dx:dx + nw] = resized
    return canvas, r, dx, dy


# ===================== LOAD MODEL =====================
if not os.path.exists(ONNX_PATH):
    print(f"[ADAS] LOI: Khong tim thay {ONNX_PATH}")
    print(f"[ADAS]      Export tu PC: yolo export model=yolov8s.pt format=onnx imgsz=192 opset=12")
    sys.exit(1)

print(f"[ADAS] Loading ONNX: {ONNX_PATH}")
print(f"[ADAS] OpenCV version: {cv2.__version__}")
try:
    net = cv2.dnn.readNetFromONNX(ONNX_PATH)
except cv2.error as e:
    print(f"[ADAS] LOI khi load ONNX: {e}")
    print(f"[ADAS] Co the OpenCV qua cu hoac opset khong tuong thich.")
    print(f"[ADAS] Thu re-export voi opset=11: yolo export ... opset=11")
    sys.exit(1)

# Backend CPU (Pi 4 khong co Vulkan/CUDA cho OpenCV DNN)
net.setPreferableBackend(cv2.dnn.DNN_BACKEND_OPENCV)
net.setPreferableTarget(cv2.dnn.DNN_TARGET_CPU)
cv2.setNumThreads(OPENCV_THREADS)
print(f"[ADAS] ONNX loaded (backend=OPENCV, target=CPU, threads={OPENCV_THREADS}, IMGSZ={IMGSZ})")


def run_inference(frame):
    """Chay 1 lan inference YOLOv5 tren 1 frame BGR."""
    global _shape_printed

    canvas, ratio, dx, dy = letterbox(frame, IMGSZ)

    blob = cv2.dnn.blobFromImage(canvas,
                                 scalefactor=1.0/255.0,
                                 size=(IMGSZ, IMGSZ),
                                 swapRB=True,
                                 crop=False)
    net.setInput(blob)
    out = net.forward()   # YOLOv5 output shape: (1, 2268, 85)

    if not _shape_printed:
        print(f"[ADAS] >>> Output shape that: {out.shape}")
        _shape_printed = True

    # Xoa dimension batch
    out = np.squeeze(out)   # -> (2268, 85) hoac (85, 2268) tuy version

    # So cot (features) cua YOLOv5 = 4 (box) + 1 (objectness) + 80 (classes) = 85
    feat = 4 + 1 + NUM_CLASSES
    
    if out.ndim != 2:
        print(f"[ADAS] Output ndim={out.ndim} la, khong xu ly duoc.")
        return []

    # Chuan hoa ve dang (So_luong_anchor, 85)
    if out.shape[1] != feat:
        if out.shape[0] == feat:
            out = out.T
        else:
            print(f"[ADAS] Output shape {out.shape} khong phai cua YOLOv5.")
            return []

    # Boc tach du lieu: [cx, cy, w, h, obj_conf, cls0...cls79]
    boxes_xywh  = out[:, 0:4]
    obj_conf    = out[:, 4]
    class_probs = out[:, 5:]

    # Tinh diem so cuoi cung = xac suat co vat the * xac suat cua class
    scores_all = class_probs * obj_conf[:, np.newaxis]

    class_ids   = np.argmax(scores_all, axis=1)
    confidences = np.max(scores_all, axis=1)

    # Loc: nguong conf + chi giu class ADAS
    keep = (confidences >= CONF_THRESH) & np.isin(class_ids, ADAS_CLASSES)
    if not np.any(keep):
        return []

    cx = boxes_xywh[keep, 0]
    cy = boxes_xywh[keep, 1]
    bw = boxes_xywh[keep, 2]
    bh = boxes_xywh[keep, 3]
    cls  = class_ids[keep]
    conf = confidences[keep]

    # x1,y1 (goc trai tren) trong toa do letterbox
    x1 = cx - bw / 2.0
    y1 = cy - bh / 2.0

    # NMS
    nms_boxes  = [[float(x1[i]), float(y1[i]), float(bw[i]), float(bh[i])]
                  for i in range(len(conf))]
    nms_scores = [float(c) for c in conf]
    idxs = cv2.dnn.NMSBoxes(nms_boxes, nms_scores, CONF_THRESH, IOU_THRESH)

    if len(idxs) == 0:
        return []
    idxs = np.array(idxs).flatten()

    idxs = idxs[np.argsort(conf[idxs])[::-1]][:MAX_DET]

    h0, w0 = frame.shape[:2]
    results = []
    for i in idxs:
        # Map nguoc tu toa do letterbox ve toa do frame goc
        ox1 = (x1[i]         - dx) / ratio
        oy1 = (y1[i]         - dy) / ratio
        ox2 = (x1[i] + bw[i] - dx) / ratio
        oy2 = (y1[i] + bh[i] - dy) / ratio
        
        # Clip ve trong khung hinh
        ox1 = max(0, min(w0 - 1, int(ox1)))
        oy1 = max(0, min(h0 - 1, int(oy1)))
        ox2 = max(0, min(w0 - 1, int(ox2)))
        oy2 = max(0, min(h0 - 1, int(oy2)))
        results.append((ox1, oy1, ox2, oy2, int(cls[i]), float(conf[i])))
        
    return results
# ----- Warmup -----
print("[ADAS] Warming up...")
_warm = np.zeros((CAMERA_HEIGHT, CAMERA_WIDTH, 3), dtype=np.uint8)
for _ in range(3):
    run_inference(_warm)
print("[ADAS] Model ready.")


# ===================== MO CAMERA =====================
# read THAM Số mode từ C++ ---
# sys.argv[1] chính là tham số mode ("0" hoặc "1") truyền từ QProcess phía trên
run_mode = int(sys.argv[1]) if len(sys.argv) > 1 else 0

if run_mode == 1:
    cap = cv2.VideoCapture(0) 
    print("[ADAS] ==Active mode: REAL-LIFE REARVIEW CAMERA==")
else:
    cap = cv2.VideoCapture("/opt/adas/cam1.mp4")
    print("[ADAS] ==Active mode: VIDEO SIMULATOR ADAS ===")

# Các dòng thiết lập kích thước camera bên dưới giữ nguyên...
cap.set(cv2.CAP_PROP_FRAME_WIDTH,  CAMERA_WIDTH)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, CAMERA_HEIGHT)
if not cap.isOpened():
    print(f"[ADAS] LOI: Khong mo duoc /dev/video{CAMERA_INDEX}.")
    print("[ADAS] Kiem tra: ls /dev/video* ; v4l2-ctl --list-devices")
    print("[ADAS] Neu dung libcamera stack: libcamerify python3 adas_realtime.py")
    sys.exit(1)

cap.set(cv2.CAP_PROP_FRAME_WIDTH,  CAMERA_WIDTH)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, CAMERA_HEIGHT)
cap.set(cv2.CAP_PROP_FPS,          CAMERA_FPS)
cap.set(cv2.CAP_PROP_BUFFERSIZE,   1)

ok, _ = cap.read()
if not ok:
    print("[ADAS] LOI: Camera mo duoc nhung khong doc duoc frame.")
    cleanup()
    sys.exit(1)

time.sleep(1)
print("[ADAS] Camera OK.")


# ===================== CAC THREAD NEN =====================
def capture_loop():
    global latest_frame
    while running:
        ok, f = cap.read()
        if not ok:
            time.sleep(0.005)
            continue
        f = cv2.resize(f, (640, 480))
        with frame_lock:
            latest_frame = f

def inference_loop():
    global latest_boxes, box_age
    while running:
        if run_mode == 1:
            time.sleep(0.1) # Ngủ 100ms để tiết kiệm CPU
            continue
        with frame_lock:
            if latest_frame is None:
                time.sleep(0.01)
                continue
            f = latest_frame.copy()
        t0 = time.time()
        try:
            boxes_data = run_inference(f)
        except Exception as e:
            print(f"[ADAS] Loi inference: {e}")
            boxes_data = []
        dt = time.time() - t0
        with result_lock:
            latest_boxes = boxes_data
            box_age = 0
            inf_times.append(dt)
            if len(inf_times) > 20:
                inf_times.pop(0)


Thread(target=capture_loop,   daemon=True).start()
time.sleep(0.5)
Thread(target=inference_loop, daemon=True).start()
time.sleep(1)


# ===================== BAO SAN SANG CHO QT =====================
with open(READY_FLAG, "w") as f:
    f.write(str(time.time()))
print("[ADAS] === ONLINE === (da tao /tmp/adas_ready)")

# ===================== LANE DETECTION (SHORT & FAST - RADAR STYLE) =====================
prev_left = None
prev_right = None

def detect_lanes(image):
    global prev_left, prev_right
    height, width = image.shape[:2]
    
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(gray, (5, 5), 0)
    edges = cv2.Canny(blur, 50, 150)
    
    mask = np.zeros_like(edges)
    # Vẫn quét vạch ở tít xa (60%) để thuật toán lấy được góc nghiêng chuẩn nhất
    scan_top = int(height * 0.6) 
    polygon = np.array([[
        (0, height),
        (width, height),
        (int(width * 0.55), scan_top),
        (int(width * 0.45), scan_top),
    ]], np.int32)
    cv2.fillPoly(mask, [polygon], 255)
    masked_edges = cv2.bitwise_and(edges, mask)
    
    lines = cv2.HoughLinesP(masked_edges, rho=1, theta=np.pi/180, 
                            threshold=20, minLineLength=15, maxLineGap=40)
    
    overlay = np.zeros_like(image)
    left_lines = []
    right_lines = []
    
    if lines is not None:
        for line in lines:
            x1, y1, x2, y2 = line[0]
            if x1 == x2: continue
            
            slope = (y2 - y1) / (x2 - x1)
            # Lọc độ dốc vừa phải
            if -2.0 < slope < -0.4:       
                left_lines.append(line)
            elif 0.4 < slope < 2.0:      
                right_lines.append(line)
                
    def get_average_line(line_group):
        if len(line_group) == 0: return None
        x_coords, y_coords = [], []
        for line in line_group:
            x1, y1, x2, y2 = line[0]
            x_coords.extend([x1, x2])
            y_coords.extend([y1, y2])
        
        poly = np.polyfit(y_coords, x_coords, 1)
        y_bottom = height
        
        # CHÌA KHÓA Ở ĐÂY: Dù quét xa, nhưng chỉ VẼ đến 80% chiều cao màn hình
        # Tạo cảm giác lane rất ngắn, nằm gọn ngay trước mũi xe
        y_top_draw = int(height * 0.8) 
        
        x_bottom = int(np.polyval(poly, y_bottom))
        x_top = int(np.polyval(poly, y_top_draw))
        return (x_bottom, y_bottom), (x_top, y_top_draw)

    curr_left = get_average_line(left_lines)
    curr_right = get_average_line(right_lines)
    
    alpha = 0.2 
    if curr_left is not None:
        if prev_left is None: prev_left = curr_left
        else:
            prev_left = (
                (int(prev_left[0][0] * (1 - alpha) + curr_left[0][0] * alpha), prev_left[0][1]),
                (int(prev_left[1][0] * (1 - alpha) + curr_left[1][0] * alpha), prev_left[1][1])
            )
            
    if curr_right is not None:
        if prev_right is None: prev_right = curr_right
        else:
            prev_right = (
                (int(prev_right[0][0] * (1 - alpha) + curr_right[0][0] * alpha), prev_right[0][1]),
                (int(prev_right[1][0] * (1 - alpha) + curr_right[1][0] * alpha), prev_right[1][1])
            )

    if prev_left and prev_right:
        pts = np.array([
            prev_left[0],  
            prev_left[1],  
            prev_right[1], 
            prev_right[0]  
        ], np.int32)
        
        # Vẽ thảm xanh
        cv2.fillPoly(overlay, [pts], (0, 255, 0))
        
        # Vẽ 2 vạch đỏ 2 bên mép
        cv2.line(overlay, prev_left[0], prev_left[1], (0, 0, 255), 3)
        cv2.line(overlay, prev_right[0], prev_right[1], (0, 0, 255), 3)
        
        # Vẽ vạch ngang màu vàng/cam ở đỉnh (Safety Distance Line)
        cv2.line(overlay, prev_left[1], prev_right[1], (0, 200, 255), 2)

    output = cv2.addWeighted(image, 1.0, overlay, 0.4, 0)
    return output
# ===================== MAIN LOOP =====================
disp_count = 0
disp_t0 = time.time()
disp_fps = 0.0
last_write = 0.0

try:
    while running:
        with frame_lock:
            if latest_frame is None:
                time.sleep(0.005)
                continue
            frame = latest_frame.copy()
        if run_mode == 0:
            frame = detect_lanes(frame)

        with result_lock:
            boxes = list(latest_boxes)
            box_age += 1
            ai_fps = len(inf_times) / sum(inf_times) if inf_times else 0.0

        boxes_fresh = box_age < 8

        # --- Ve bounding box ---
        if run_mode == 0 and boxes_fresh:
            for x1, y1, x2, y2, c, cf in boxes:
                color = COLOR_MAP.get(c, (0, 255, 0))
                name  = VIET_NAMES.get(c, str(c))
                label = f"{name} {cf*100:.0f}%"
                cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
                (lw, lh), _ = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.4, 1)
                cv2.rectangle(frame, (x1, y1-lh-4), (x1+lw+2, y1), color, -1)
                cv2.putText(frame, label, (x1+1, y1-3),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.4, (255, 255, 255), 1)

        disp_count += 1
        if disp_count % 30 == 0:
            now = time.time()
            disp_fps = 30 / (now - disp_t0) if now > disp_t0 else 0.0
            disp_t0 = now

        obj_count = len(boxes) if boxes_fresh else 0
        cv2.putText(frame,
                    f"VIDEO: {disp_fps:.0f}fps | AI: {ai_fps:.1f}fps | Obj: {obj_count}",
                    (5, 15), cv2.FONT_HERSHEY_SIMPLEX, 0.4, (0, 255, 0), 1)

        # --- Ghi file IPC cho Qt (throttle ~20Hz) ---
        now = time.time()
        if now - last_write >= WRITE_INTERVAL:
            last_write = now
            objects = []
            if boxes_fresh:
                for _, _, _, _, c, cf in boxes:
                    objects.append(f"{VIET_NAMES.get(c, str(c))} {cf*100:.0f}%")
            try:
                write_frame_atomic(frame)
                write_stats_atomic(disp_fps, ai_fps, obj_count, objects)
            except Exception as e:
                print(f"[ADAS] Loi ghi file IPC: {e}")

        time.sleep(0.005)

except Exception as e:
    print(f"[ADAS] Loi main loop: {e}")

finally:
    running = False
    time.sleep(0.3)
    cleanup()

