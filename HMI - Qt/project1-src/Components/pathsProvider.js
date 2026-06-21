.pragma library

// Đường dẫn tương đối từ Components/ lên project root, rồi vào assets/images/
function getImagePath(name) {
    return Qt.resolvedUrl("../assets/images/" + name)
}

function getIconPath(name) {
    return Qt.resolvedUrl("../assets/icons/" + name)
}

function getSoundPath(name) {
    return Qt.resolvedUrl("../assets/sounds/" + name)
}
