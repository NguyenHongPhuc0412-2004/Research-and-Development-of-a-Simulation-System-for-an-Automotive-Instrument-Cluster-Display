import QtQuick 2.15
import QtQuick3D 1.15

Node {
    id: sketchfab_model
    eulerRotation.x: -90

    Node {
        id: root

        Node {
            id: gLTF_SceneRootNode
            eulerRotation.x: 90

            Node {
                id: sketchfab_model_0
                eulerRotation.x: -90

                Node {
                    id: node888d5b4c0a7b42299d217c2edec42266_fbx_1
                    eulerRotation.x: 90

                    Node {
                        id: rootNode_2

                        Node {
                            id: tesla_Model_3_3
                            eulerRotation.x: -90
                            scale.x: 100
                            scale.y: 100
                            scale.z: 100

                            Node {
                                id: hub_rb_4
                                x: 0.898338
                                y: -1.44654
                                z: -0.37177
                                eulerRotation.x: -1.51661e-21

                                Node {
                                    id: hub_rb_hub_rb_0_0_5

                                    Model {
                                        id: object_9
                                        source: "meshes/object_9.mesh"

                                        PrincipledMaterial {
                                            id: hub_rb_0_material
                                            baseColorMap: Texture {
                                                source: "maps/hub_rb.0_baseColor.png"
                                                tilingModeHorizontal: Texture.Repeat
                                                tilingModeVertical: Texture.Repeat
                                            }
                                            opacityChannel: Material.A
                                            metalness: 0
                                            roughness: 1
                                            cullMode: Material.NoCulling
                                        }
                                        materials: [
                                            hub_rb_0_material
                                        ]
                                    }
                                }
                            }

                            Node {
                                id: hub_lb_6
                                x: -0.898226
                                y: -1.44647
                                z: -0.37177
                                eulerRotation.x: -1.51661e-21

                                Node {
                                    id: hub_lb_hub_rb_0_0_7

                                    Model {
                                        id: object_12
                                        source: "meshes/object_12.mesh"
                                        materials: [
                                            hub_rb_0_material
                                        ]
                                    }
                                }
                            }

                            Node {
                                id: hub_rf_8
                                x: 0.924155
                                y: 1.7566
                                z: -0.371791
                                eulerRotation.x: -1.51661e-21

                                Node {
                                    id: hub_rf_hub_rf_0_0_9

                                    Model {
                                        id: object_15
                                        source: "meshes/object_15.mesh"

                                        PrincipledMaterial {
                                            id: hub_rf_0_material
                                            baseColorMap: Texture {
                                                source: "maps/hub_rb.0_baseColor.png"
                                                tilingModeHorizontal: Texture.Repeat
                                                tilingModeVertical: Texture.Repeat
                                            }
                                            opacityChannel: Material.A
                                            metalness: 0
                                            roughness: 0.692518
                                            cullMode: Material.NoCulling
                                        }
                                        materials: [
                                            hub_rf_0_material
                                        ]
                                    }
                                }

                                Node {
                                    id: hub_rf_hub_rf_1_0_10

                                    Model {
                                        id: object_17
                                        source: "meshes/object_17.mesh"

                                        PrincipledMaterial {
                                            id: hub_rf_1_material
                                            baseColorMap: Texture {
                                                source: "maps/hub_rf.1_baseColor.png"
                                                tilingModeHorizontal: Texture.Repeat
                                                tilingModeVertical: Texture.Repeat
                                            }
                                            opacityChannel: Material.A
                                            metalness: 0
                                            roughness: 1
                                            cullMode: Material.NoCulling
                                        }
                                        materials: [
                                            hub_rf_1_material
                                        ]
                                    }
                                }
                            }

                            Node {
                                id: hub_lf_11
                                x: -0.924874
                                y: 1.7566
                                z: -0.371791
                                eulerRotation.x: -1.51661e-21

                                Node {
                                    id: hub_lf_hub_rf_0_0_12

                                    Model {
                                        id: object_20
                                        source: "meshes/object_20.mesh"
                                        materials: [
                                            hub_rf_0_material
                                        ]
                                    }
                                }

                                Node {
                                    id: hub_lf_hub_rf_1_0_13

                                    Model {
                                        id: object_22
                                        source: "meshes/object_22.mesh"
                                        materials: [
                                            hub_rf_1_material
                                        ]
                                    }
                                }
                            }

                            Node {
                                id: dvornik_dummy_14
                                x: -0.0828764
                                y: 1.60456
                                z: 0.17731
                                eulerRotation.x: 54.7549
                                scale.y: 1
                                scale.z: 1

                                Node {
                                    id: dvorright_15
                                    x: -7.07954e-05
                                    y: 4.80413e-05
                                    z: -6.19888e-05
                                    eulerRotation.x: -9.85972e-14
                                    scale.z: 1

                                    Node {
                                        id: dvorright_dvorright_0_0_16

                                        Model {
                                            id: object_26
                                            source: "meshes/object_26.mesh"

                                            PrincipledMaterial {
                                                id: dvorright_0_material
                                                baseColorMap: Texture {
                                                    source: "maps/dvorright.0_baseColor.png"
                                                    tilingModeHorizontal: Texture.Repeat
                                                    tilingModeVertical: Texture.Repeat
                                                }
                                                opacityChannel: Material.A
                                                metalness: 0
                                                roughness: 1
                                                cullMode: Material.NoCulling
                                            }
                                            materials: [
                                                dvorright_0_material
                                            ]
                                        }
                                    }
                                }

                                Node {
                                    id: other_17
                                    x: -0.622816
                                    y: -0.0792368
                                    z: 0.170684
                                    eulerRotation.x: 7.59312
                                    scale.y: 1
                                    scale.z: 1

                                    Node {
                                        id: dvorleft_18
                                        x: -7.08699e-05
                                        y: 3.91603e-05
                                        z: -6.78301e-05
                                        eulerRotation.x: -6.36111e-15
                                        scale.y: 1
                                        scale.z: 1

                                        Node {
                                            id: dvorleft_dvorright_0_0_19

                                            Model {
                                                id: object_30
                                                source: "meshes/object_30.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }
                                    }
                                }
                            }

                            Node {
                                id: steering_dummy_20
                                x: -0.469958
                                y: 0.60791
                                z: 0.17581
                                eulerRotation.x: -17.625
                                scale.y: 1

                                Node {
                                    id: movsteer_1_0_21
                                    x: 7.42078e-06
                                    y: 5.00679e-06
                                    z: 6.85453e-07
                                    eulerRotation.x: -1.70755e-06
                                    scale.y: 1

                                    Node {
                                        id: movsteer_1_0_movsteer_1_0_1_0_22

                                        Model {
                                            id: object_34
                                            source: "meshes/object_34.mesh"

                                            PrincipledMaterial {
                                                id: movsteer_1_0_1_material
                                                baseColorMap: Texture {
                                                    source: "maps/movsteer_1.0.1_baseColor.png"
                                                    tilingModeHorizontal: Texture.Repeat
                                                    tilingModeVertical: Texture.Repeat
                                                }
                                                opacityChannel: Material.A
                                                metalness: 0.71917
                                                roughness: 0.420674
                                                cullMode: Material.NoCulling
                                            }
                                            materials: [
                                                movsteer_1_0_1_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: movsteer_1_0_movsteer_1_0_0_0_23

                                        Model {
                                            id: object_36
                                            source: "meshes/object_36.mesh"

                                            PrincipledMaterial {
                                                id: movsteer_1_0_0_material
                                                baseColorMap: Texture {
                                                    source: "maps/movsteer_1.0.0_baseColor.png"
                                                    tilingModeHorizontal: Texture.Repeat
                                                    tilingModeVertical: Texture.Repeat
                                                }
                                                opacityChannel: Material.A
                                                metalness: 0
                                                roughness: 1
                                                cullMode: Material.NoCulling
                                            }
                                            materials: [
                                                movsteer_1_0_0_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: movsteer_1_0_dvorright_0_0_24

                                        Model {
                                            id: object_38
                                            source: "meshes/object_38.mesh"
                                            materials: [
                                                dvorright_0_material
                                            ]
                                        }
                                    }
                                }
                            }

                            Node {
                                id: chassis_dummy_25
                                eulerRotation.x: -1.51661e-21

                                Node {
                                    id: chassis_26
                                    y: 1.77061
                                    z: -0.362406
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: chassis_chassis_0_0_27

                                        Model {
                                            id: object_42
                                            source: "meshes/object_42.mesh"

                                            PrincipledMaterial {
                                                id: chassis_0_material
                                                baseColor: "#ffcccccc"
                                                metalness: 0
                                                roughness: 1
                                                cullMode: Material.NoCulling
                                            }
                                            materials: [
                                                chassis_0_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: jUST_BLACK_28
                                        y: -1.77061
                                        z: 0.362406
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: jUST_BLACK_JUST_BLACK_0_0_29

                                            Model {
                                                id: object_45
                                                source: "meshes/object_45.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: jUST_BLACK_001_30

                                            Node {
                                                id: jUST_BLACK_001_JUST_BLACK_0_0_31

                                                Model {
                                                    id: object_48
                                                    source: "meshes/object_48.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }
                                    }

                                    Node {
                                        id: body_32
                                        y: -1.77061
                                        z: 0.362406
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: body_primary_0_33

                                            Model {
                                                id: object_51
                                                source: "meshes/object_51.mesh"

                                                PrincipledMaterial {
                                                    id: primary_material
                                                    baseColor: "#ffd1d1d1"
                                                    metalness: 0
                                                    roughness: 0.28083
                                                    cullMode: Material.NoCulling
                                                }
                                                materials: [
                                                    primary_material
                                                ]
                                            }
                                        }
                                    }

                                    Node {
                                        id: bodysills_34
                                        y: -1.77061
                                        z: 0.362406
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: bodysills_primary_001_0_35

                                            Model {
                                                id: object_54
                                                source: "meshes/object_54.mesh"

                                                PrincipledMaterial {
                                                    id: primary_001_material
                                                    baseColorMap: Texture {
                                                        source: "maps/primary.001_baseColor.png"
                                                        tilingModeHorizontal: Texture.Repeat
                                                        tilingModeVertical: Texture.Repeat
                                                    }
                                                    opacityChannel: Material.A
                                                    metalness: 0
                                                    roughness: 1
                                                    cullMode: Material.NoCulling
                                                }
                                                materials: [
                                                    primary_001_material
                                                ]
                                            }
                                        }
                                    }

                                    Node {
                                        id: black_lights_36
                                        y: -1.77061
                                        z: 0.362406
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: black_lights_black_lights_0_0_37

                                            Model {
                                                id: object_57
                                                source: "meshes/object_57.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: _satin_black_134_38

                                            Node {
                                                id: _satin_black_134_black_lights_0_0_39

                                                Model {
                                                    id: object_60
                                                    source: "meshes/object_60.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }

                                            Node {
                                                id: _plastic_black_124_40
                                                eulerRotation.x: -3.03321e-21

                                                Node {
                                                    id: _plastic_black_124_black_lights_0_0_41

                                                    Model {
                                                        id: object_63
                                                        source: "meshes/object_63.mesh"
                                                        materials: [
                                                            dvorright_0_material
                                                        ]
                                                    }
                                                }
                                            }
                                        }

                                        Node {
                                            id: back_chrome_light_42

                                            Node {
                                                id: back_chrome_light_back_chrome_light_0_0_43

                                                Model {
                                                    id: object_66
                                                    source: "meshes/object_66.mesh"

                                                    PrincipledMaterial {
                                                        id: back_chrome_light_0_material
                                                        baseColorMap: Texture {
                                                            source: "maps/back_chrome_light.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        opacityChannel: Material.A
                                                        metalness: 0
                                                        roughness: 1
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        back_chrome_light_0_material
                                                    ]
                                                }
                                            }

                                            Node {
                                                id: pantulans_44
                                                eulerRotation.x: -3.03321e-21

                                                Node {
                                                    id: pantulans_pantulans_0_0_45

                                                    Model {
                                                        id: object_69
                                                        source: "meshes/object_69.mesh"

                                                        PrincipledMaterial {
                                                            id: pantulans_0_material
                                                            baseColorMap: Texture {
                                                                source: "maps/pantulans.0_baseColor.png"
                                                                tilingModeHorizontal: Texture.Repeat
                                                                tilingModeVertical: Texture.Repeat
                                                            }
                                                            opacityChannel: Material.A
                                                            metalness: 0
                                                            roughness: 1
                                                            emissiveMap: Texture {
                                                                source: "maps/pantulans.0_baseColor.png"
                                                                tilingModeHorizontal: Texture.Repeat
                                                                tilingModeVertical: Texture.Repeat
                                                            }
                                                            emissiveColor: "#ffffffff"
                                                            cullMode: Material.NoCulling
                                                        }
                                                        materials: [
                                                            pantulans_0_material
                                                        ]
                                                    }
                                                }
                                            }

                                            Node {
                                                id: rear_lights_46
                                                eulerRotation.x: -3.03321e-21

                                                Node {
                                                    id: rear_lights_right_rear_light_0_47

                                                    Model {
                                                        id: object_72
                                                        source: "meshes/object_72.mesh"

                                                        PrincipledMaterial {
                                                            id: right_rear_light_material
                                                            baseColorMap: Texture {
                                                                source: "maps/right_rear_light_baseColor.png"
                                                                tilingModeHorizontal: Texture.Repeat
                                                                tilingModeVertical: Texture.Repeat
                                                            }
                                                            opacityChannel: Material.A
                                                            metalness: 0
                                                            roughness: 1
                                                            emissiveMap: Texture {
                                                                source: "maps/right_rear_light_baseColor.png"
                                                                tilingModeHorizontal: Texture.Repeat
                                                                tilingModeVertical: Texture.Repeat
                                                            }
                                                            emissiveColor: "#ffffffff"
                                                            cullMode: Material.NoCulling
                                                        }
                                                        materials: [
                                                            right_rear_light_material
                                                        ]
                                                    }
                                                }
                                            }

                                            Node {
                                                id: light_breake_48
                                                eulerRotation.x: -3.03321e-21

                                                Node {
                                                    id: light_breake_breaklight_l_0_49

                                                    Model {
                                                        id: object_75
                                                        source: "meshes/object_75.mesh"

                                                        PrincipledMaterial {
                                                            id: breaklight_l_material
                                                            baseColorMap: Texture {
                                                                source: "maps/right_rear_light_baseColor.png"
                                                                tilingModeHorizontal: Texture.Repeat
                                                                tilingModeVertical: Texture.Repeat
                                                            }
                                                            opacityChannel: Material.A
                                                            metalness: 0
                                                            roughness: 1
                                                            cullMode: Material.NoCulling
                                                        }
                                                        materials: [
                                                            breaklight_l_material
                                                        ]
                                                    }
                                                }
                                            }
                                        }

                                        Node {
                                            id: chrome_foglight_r_50

                                            Node {
                                                id: chrome_foglight_r_foglight_r_0_51

                                                Model {
                                                    id: object_78
                                                    source: "meshes/object_78.mesh"
                                                    materials: [
                                                        breaklight_l_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: chrome_foglight_l_52

                                            Node {
                                                id: chrome_foglight_l_foglight_l_0_53

                                                Model {
                                                    id: object_81
                                                    source: "meshes/object_81.mesh"
                                                    materials: [
                                                        breaklight_l_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: chrome_Lights_head_l_54

                                            Node {
                                                id: chrome_Lights_head_l_right_front_light_0_55

                                                Model {
                                                    id: object_84
                                                    source: "meshes/object_84.mesh"
                                                    materials: [
                                                        breaklight_l_material
                                                    ]
                                                }
                                            }

                                            Node {
                                                id: chrome_Lights_head_l_left_front_light_0_56

                                                Model {
                                                    id: object_86
                                                    source: "meshes/object_86.mesh"
                                                    materials: [
                                                        right_rear_light_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: chrome_57

                                            Node {
                                                id: chrome_movsteer_1_0_1_0_58

                                                Model {
                                                    id: object_89
                                                    source: "meshes/object_89.mesh"
                                                    materials: [
                                                        movsteer_1_0_1_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: breake_int_59

                                            Node {
                                                id: breake_int_breaklight_l_0_60

                                                Model {
                                                    id: object_92
                                                    source: "meshes/object_92.mesh"
                                                    materials: [
                                                        breaklight_l_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: aluminium_light_61

                                            Node {
                                                id: aluminium_light_aluminium_light_0_0_62

                                                Model {
                                                    id: object_95
                                                    source: "meshes/object_95.mesh"

                                                    PrincipledMaterial {
                                                        id: aluminium_light_0_material
                                                        baseColorMap: Texture {
                                                            source: "maps/movsteer_1.0.1_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        opacityChannel: Material.A
                                                        metalness: 0
                                                        roughness: 1
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        aluminium_light_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: tembus_red_63

                                            Node {
                                                id: tembus_red_tembus_red_0_0_64

                                                Model {
                                                    id: object_98
                                                    source: "meshes/object_98.mesh"

                                                    PrincipledMaterial {
                                                        id: tembus_red_0_material
                                                        baseColor: "#d0ffffff"
                                                        baseColorMap: Texture {
                                                            source: "maps/tembus_red.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        opacityChannel: Material.A
                                                        metalness: 0
                                                        roughness: 0.766163
                                                        cullMode: Material.NoCulling
                                                        alphaMode: PrincipledMaterial.Blend
                                                    }
                                                    materials: [
                                                        tembus_red_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: interiorlights_65

                                            Node {
                                                id: interiorlights_light_night_0_66

                                                Model {
                                                    id: object_101
                                                    source: "meshes/object_101.mesh"
                                                    materials: [
                                                        right_rear_light_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: turn_indicat_l_67
                                            x: 0.00181705

                                            Node {
                                                id: turn_indicat_l_indicator_lf_0_68

                                                Model {
                                                    id: object_104
                                                    source: "meshes/object_104.mesh"
                                                    materials: [
                                                        right_rear_light_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: turn_indicat_r_69
                                            x: 0.00181705

                                            Node {
                                                id: turn_indicat_r_indicator_rf_0_70

                                                Model {
                                                    id: object_107
                                                    source: "meshes/object_107.mesh"
                                                    materials: [
                                                        right_rear_light_material
                                                    ]
                                                }
                                            }
                                        }
                                    }

                                    Node {
                                        id: base_71
                                        y: -1.77061
                                        z: 0.362406
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: base_dvorright_0_0_72

                                            Model {
                                                id: object_110
                                                source: "meshes/object_110.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: hitam_73

                                            Node {
                                                id: hitam_dvorright_0_0_74

                                                Model {
                                                    id: object_113
                                                    source: "meshes/object_113.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: hitam_001_75

                                            Node {
                                                id: hitam_001_dvorright_0_0_76

                                                Model {
                                                    id: object_116
                                                    source: "meshes/object_116.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: hitam_002_77

                                            Node {
                                                id: hitam_002_hitam_0_0_78

                                                Model {
                                                    id: object_119
                                                    source: "meshes/object_119.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: plastic_79

                                            Node {
                                                id: plastic_Plastic_0_0_80

                                                Model {
                                                    id: object_122
                                                    source: "meshes/object_122.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: belt_81

                                            Node {
                                                id: belt_belt_0_0_82

                                                Model {
                                                    id: object_125
                                                    source: "meshes/object_125.mesh"

                                                    PrincipledMaterial {
                                                        id: belt_0_material
                                                        baseColorMap: Texture {
                                                            source: "maps/belt.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        opacityChannel: Material.A
                                                        metalness: 0
                                                        roughness: 1
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        belt_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: black_83

                                            Node {
                                                id: black_black_lights_0_0_84

                                                Model {
                                                    id: object_128
                                                    source: "meshes/object_128.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: satin_red_85

                                            Node {
                                                id: satin_red_satin_red_0_0_86

                                                Model {
                                                    id: object_131
                                                    source: "meshes/object_131.mesh"

                                                    PrincipledMaterial {
                                                        id: satin_red_0_material
                                                        baseColorMap: Texture {
                                                            source: "maps/pantulans.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        opacityChannel: Material.A
                                                        metalness: 0
                                                        roughness: 1
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        satin_red_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: paint_black_87

                                            Node {
                                                id: paint_black_dvorright_0_0_88

                                                Model {
                                                    id: object_134
                                                    source: "meshes/object_134.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: cahrome_89

                                            Node {
                                                id: cahrome_movsteer_1_0_1_0_90

                                                Model {
                                                    id: object_137
                                                    source: "meshes/object_137.mesh"
                                                    materials: [
                                                        movsteer_1_0_1_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: suspensi_91

                                            Node {
                                                id: suspensi_suspensi_0_0_92

                                                Model {
                                                    id: object_140
                                                    source: "meshes/object_140.mesh"
                                                    materials: [
                                                        back_chrome_light_0_material
                                                    ]
                                                }
                                            }

                                            Node {
                                                id: suspensi_suspensi_1_0_93

                                                Model {
                                                    id: object_142
                                                    source: "meshes/object_142.mesh"
                                                    materials: [
                                                        back_chrome_light_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: chrome__94

                                            Node {
                                                id: chrome__movsteer_1_0_1_0_95

                                                Model {
                                                    id: object_145
                                                    source: "meshes/object_145.mesh"
                                                    materials: [
                                                        movsteer_1_0_1_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: chrome1_96

                                            Node {
                                                id: chrome1_movsteer_1_0_1_0_97

                                                Model {
                                                    id: object_148
                                                    source: "meshes/object_148.mesh"
                                                    materials: [
                                                        movsteer_1_0_1_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: chrome2_98

                                            Node {
                                                id: chrome2_movsteer_1_0_1_0_99

                                                Model {
                                                    id: object_151
                                                    source: "meshes/object_151.mesh"
                                                    materials: [
                                                        movsteer_1_0_1_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: hitam_003_100

                                            Node {
                                                id: hitam_003_dvorright_0_0_101

                                                Model {
                                                    id: object_154
                                                    source: "meshes/object_154.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: hitam_004_102

                                            Node {
                                                id: hitam_004_dvorright_0_0_103

                                                Model {
                                                    id: object_157
                                                    source: "meshes/object_157.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: aluminium_104

                                            Node {
                                                id: aluminium_movsteer_1_0_1_0_105

                                                Model {
                                                    id: object_160
                                                    source: "meshes/object_160.mesh"
                                                    materials: [
                                                        movsteer_1_0_1_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: hitam_005_106

                                            Node {
                                                id: hitam_005_Plastic_0_0_107

                                                Model {
                                                    id: object_163
                                                    source: "meshes/object_163.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: hitam_006_108

                                            Node {
                                                id: hitam_006_black_lights_0_0_109

                                                Model {
                                                    id: object_166
                                                    source: "meshes/object_166.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: texture_Leather_110

                                            Node {
                                                id: texture_Leather_movsteer_1_0_0_0_111

                                                Model {
                                                    id: object_169
                                                    source: "meshes/object_169.mesh"
                                                    materials: [
                                                        movsteer_1_0_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: texture_Leather_001_112

                                            Node {
                                                id: texture_Leather_001_movsteer_1_0_0_0_113

                                                Model {
                                                    id: object_172
                                                    source: "meshes/object_172.mesh"
                                                    materials: [
                                                        movsteer_1_0_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: aluminium2_114

                                            Node {
                                                id: aluminium2_aluminium2_0_0_115

                                                Model {
                                                    id: object_175
                                                    source: "meshes/object_175.mesh"
                                                    materials: [
                                                        aluminium_light_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: frunkplastic_116

                                            Node {
                                                id: frunkplastic_dvorright_0_0_117

                                                Model {
                                                    id: object_178
                                                    source: "meshes/object_178.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: putih_118

                                            Node {
                                                id: putih_Putih_0_0_119

                                                Model {
                                                    id: object_181
                                                    source: "meshes/object_181.mesh"

                                                    PrincipledMaterial {
                                                        id: putih_0_material
                                                        baseColorMap: Texture {
                                                            source: "maps/Putih.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        opacityChannel: Material.A
                                                        metalness: 0
                                                        roughness: 1
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        putih_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: whiteleather_120

                                            Node {
                                                id: whiteleather_Putih_0_0_121

                                                Model {
                                                    id: object_184
                                                    source: "meshes/object_184.mesh"
                                                    materials: [
                                                        putih_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: putih_001_122

                                            Node {
                                                id: putih_001_Putih_0_0_123

                                                Model {
                                                    id: object_187
                                                    source: "meshes/object_187.mesh"
                                                    materials: [
                                                        putih_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: putih_002_124

                                            Node {
                                                id: putih_002_Putih_0_0_125

                                                Model {
                                                    id: object_190
                                                    source: "meshes/object_190.mesh"
                                                    materials: [
                                                        putih_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: carpet_126

                                            Node {
                                                id: carpet_Carpet_0_0_127

                                                Model {
                                                    id: object_193
                                                    source: "meshes/object_193.mesh"
                                                    materials: [
                                                        movsteer_1_0_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: black_001_128

                                            Node {
                                                id: black_001_Plastic_0_0_129

                                                Model {
                                                    id: object_196
                                                    source: "meshes/object_196.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: black_002_130

                                            Node {
                                                id: black_002_Plastic_0_0_131

                                                Model {
                                                    id: object_199
                                                    source: "meshes/object_199.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: black_003_132

                                            Node {
                                                id: black_003_black_lights_0_0_133

                                                Model {
                                                    id: object_202
                                                    source: "meshes/object_202.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: black_004_134

                                            Node {
                                                id: black_004_JUST_BLACK_0_0_135

                                                Model {
                                                    id: object_205
                                                    source: "meshes/object_205.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: black_005_136

                                            Node {
                                                id: black_005_black_lights_0_0_137

                                                Model {
                                                    id: object_208
                                                    source: "meshes/object_208.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: carpet_Light_138

                                            Node {
                                                id: carpet_Light_Carpet_Light_0_0_139

                                                Model {
                                                    id: object_211
                                                    source: "meshes/object_211.mesh"

                                                    PrincipledMaterial {
                                                        id: carpet_Light_0_material
                                                        baseColor: "#ff242424"
                                                        metalness: 0
                                                        roughness: 1
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        carpet_Light_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: chromeBELT_140

                                            Node {
                                                id: chromeBELT_movsteer_1_0_1_0_141

                                                Model {
                                                    id: object_214
                                                    source: "meshes/object_214.mesh"
                                                    materials: [
                                                        movsteer_1_0_1_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: suspensi2_142

                                            Node {
                                                id: suspensi2_suspensi_0_0_143

                                                Model {
                                                    id: object_217
                                                    source: "meshes/object_217.mesh"
                                                    materials: [
                                                        back_chrome_light_0_material
                                                    ]
                                                }
                                            }

                                            Node {
                                                id: suspensi2_suspensi_1_0_144

                                                Model {
                                                    id: object_219
                                                    source: "meshes/object_219.mesh"
                                                    materials: [
                                                        back_chrome_light_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: texture_Buttons_145

                                            Node {
                                                id: texture_Buttons_texture_Buttons_0_0_146

                                                Model {
                                                    id: object_222
                                                    source: "meshes/object_222.mesh"

                                                    PrincipledMaterial {
                                                        id: texture_Buttons_0_material
                                                        baseColorMap: Texture {
                                                            source: "maps/texture_Buttons.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        opacityChannel: Material.A
                                                        metalness: 0
                                                        roughness: 1
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        texture_Buttons_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: lCDs_147

                                            Node {
                                                id: lCDs_LCDs_0_0_148

                                                Model {
                                                    id: object_225
                                                    source: "meshes/object_225.mesh"

                                                    PrincipledMaterial {
                                                        id: lCDs_0_material
                                                        baseColorMap: Texture {
                                                            source: "maps/LCDs.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        opacityChannel: Material.A
                                                        metalness: 0
                                                        roughness: 1
                                                        emissiveMap: Texture {
                                                            source: "maps/LCDs.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        emissiveColor: "#ffffffff"
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        lCDs_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: seat_Leather_white_149

                                            Node {
                                                id: seat_Leather_white_Seat_Leather_white_0_0_150

                                                Model {
                                                    id: object_228
                                                    source: "meshes/object_228.mesh"
                                                    materials: [
                                                        putih_0_material
                                                    ]
                                                }
                                            }

                                            Node {
                                                id: leather_white_151
                                                eulerRotation.x: -3.03321e-21

                                                Node {
                                                    id: leather_white_Seat_Leather_white_0_0_152

                                                    Model {
                                                        id: object_231
                                                        source: "meshes/object_231.mesh"
                                                        materials: [
                                                            putih_0_material
                                                        ]
                                                    }
                                                }
                                            }
                                        }

                                        Node {
                                            id: mirror_inside_153

                                            Node {
                                                id: mirror_inside_mirror_inside_0_0_154

                                                Model {
                                                    id: object_234
                                                    source: "meshes/object_234.mesh"

                                                    PrincipledMaterial {
                                                        id: mirror_inside_0_material
                                                        baseColor: "#ffcccccc"
                                                        roughness: 0.201787
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        mirror_inside_0_material
                                                    ]
                                                }
                                            }
                                        }
                                    }

                                    Node {
                                        id: glass_155
                                        y: -1.04158
                                        z: 0.93493
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: glass_glass_0_0_156

                                            Model {
                                                id: object_237
                                                source: "meshes/object_237.mesh"

                                                PrincipledMaterial {
                                                    id: glass_0_material
                                                    baseColor: "#9fffffff"
                                                    baseColorMap: Texture {
                                                        source: "maps/glass.0_baseColor.png"
                                                        tilingModeHorizontal: Texture.Repeat
                                                        tilingModeVertical: Texture.Repeat
                                                    }
                                                    opacityChannel: Material.A
                                                    metalness: 0
                                                    roughness: 0.220028
                                                    cullMode: Material.NoCulling
                                                    alphaMode: PrincipledMaterial.Blend
                                                }
                                                materials: [
                                                    glass_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: glass_glass_1_0_157

                                            Model {
                                                id: object_239
                                                source: "meshes/object_239.mesh"

                                                PrincipledMaterial {
                                                    id: glass_1_material
                                                    baseColor: "#a9ffffff"
                                                    baseColorMap: Texture {
                                                        source: "maps/glass.1_baseColor.png"
                                                        tilingModeHorizontal: Texture.Repeat
                                                        tilingModeVertical: Texture.Repeat
                                                    }
                                                    opacityChannel: Material.A
                                                    metalness: 0
                                                    roughness: 0.262589
                                                    cullMode: Material.NoCulling
                                                    alphaMode: PrincipledMaterial.Blend
                                                }
                                                materials: [
                                                    glass_1_material
                                                ]
                                            }
                                        }
                                    }
                                }

                                Node {
                                    id: boot_dummy_158
                                    y: -1.69223
                                    z: 0.597245
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: black_boot_159
                                        y: 8.46386e-06
                                        z: 1.51396e-05
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: black_boot_black_lights_0_0_160

                                            Model {
                                                id: object_243
                                                source: "meshes/object_243.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: boot_161
                                            y: -2.15769e-05
                                            z: -1.09673e-05

                                            Node {
                                                id: boot_primary_0_162

                                                Model {
                                                    id: object_246
                                                    source: "meshes/object_246.mesh"
                                                    materials: [
                                                        primary_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: platnomor_163

                                            Node {
                                                id: platnomor_JUST_BLACK_0_0_164

                                                Model {
                                                    id: object_249
                                                    source: "meshes/object_249.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }

                                            Node {
                                                id: platnomor_platnomor_1_0_165

                                                Model {
                                                    id: object_251
                                                    source: "meshes/object_251.mesh"

                                                    PrincipledMaterial {
                                                        id: platnomor_1_material
                                                        baseColor: "#ffa3a3a3"
                                                        metalness: 0
                                                        roughness: 1
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        platnomor_1_material
                                                    ]
                                                }
                                            }

                                            Node {
                                                id: platnomor_hitam_0_0_166

                                                Model {
                                                    id: object_253
                                                    source: "meshes/object_253.mesh"
                                                    materials: [
                                                        dvorright_0_material
                                                    ]
                                                }
                                            }

                                            Node {
                                                id: platnomor_platnomor_2_0_167

                                                Model {
                                                    id: object_255
                                                    source: "meshes/object_255.mesh"
                                                    materials: [
                                                        chassis_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: chrome_001_168

                                            Node {
                                                id: chrome_001_movsteer_1_0_1_0_169

                                                Model {
                                                    id: object_258
                                                    source: "meshes/object_258.mesh"
                                                    materials: [
                                                        movsteer_1_0_1_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: light_turn_rr_boot_170

                                            Node {
                                                id: light_turn_rr_boot_indicator_rr_0_171

                                                Model {
                                                    id: object_261
                                                    source: "meshes/object_261.mesh"
                                                    materials: [
                                                        breaklight_l_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: light_turn_lr_boot_172

                                            Node {
                                                id: light_turn_lr_boot_indicator_lr_0_173

                                                Model {
                                                    id: object_264
                                                    source: "meshes/object_264.mesh"

                                                    PrincipledMaterial {
                                                        id: indicator_lr_material
                                                        baseColor: "#ffb5ff00"
                                                        metalness: 0
                                                        roughness: 1
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        indicator_lr_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: chrome_light_174

                                            Node {
                                                id: chrome_light_back_chrome_light_0_0_175

                                                Model {
                                                    id: object_267
                                                    source: "meshes/object_267.mesh"
                                                    materials: [
                                                        back_chrome_light_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: rear_lightsr_176

                                            Node {
                                                id: rear_lightsr_right_rear_light_0_177

                                                Model {
                                                    id: object_270
                                                    source: "meshes/object_270.mesh"
                                                    materials: [
                                                        right_rear_light_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: rear_lightsl_178

                                            Node {
                                                id: rear_lightsl_left_rear_light_0_179

                                                Model {
                                                    id: object_273
                                                    source: "meshes/object_273.mesh"
                                                    materials: [
                                                        breaklight_l_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: lightrevese_boot_180

                                            Node {
                                                id: lightrevese_boot_revlight_L_0_181

                                                Model {
                                                    id: object_276
                                                    source: "meshes/object_276.mesh"
                                                    materials: [
                                                        breaklight_l_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: tembus_boot_ok_182

                                            Node {
                                                id: tembus_boot_ok_tembus_red_0_0_183

                                                Model {
                                                    id: object_279
                                                    source: "meshes/object_279.mesh"
                                                    materials: [
                                                        tembus_red_0_material
                                                    ]
                                                }
                                            }
                                        }
                                    }
                                }

                                Node {
                                    id: door_lf_dummy_184
                                    x: -1.00598
                                    y: 1.17528
                                    z: -0.0625812
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: door_lf_185
                                        x: 7.39098e-06
                                        y: -4.17233e-06
                                        z: 6.93649e-06
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: door_lf_JUST_BLACK_0_0_186

                                            Model {
                                                id: object_283
                                                source: "meshes/object_283.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_texture_Buttons_0_0_187

                                            Model {
                                                id: object_285
                                                source: "meshes/object_285.mesh"
                                                materials: [
                                                    texture_Buttons_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_movsteer_1_0_1_0_188

                                            Model {
                                                id: object_287
                                                source: "meshes/object_287.mesh"
                                                materials: [
                                                    movsteer_1_0_1_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_movsteer_1_0_0_0_189

                                            Model {
                                                id: object_289
                                                source: "meshes/object_289.mesh"
                                                materials: [
                                                    movsteer_1_0_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_Putih_0_0_190

                                            Model {
                                                id: object_291
                                                source: "meshes/object_291.mesh"
                                                materials: [
                                                    putih_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_Plastic_0_0_191

                                            Model {
                                                id: object_293
                                                source: "meshes/object_293.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_aluminium2_0_0_192

                                            Model {
                                                id: object_295
                                                source: "meshes/object_295.mesh"
                                                materials: [
                                                    aluminium_light_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_dvorright_0_0_193

                                            Model {
                                                id: object_297
                                                source: "meshes/object_297.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_door_lf_0_0_194

                                            Model {
                                                id: object_299
                                                source: "meshes/object_299.mesh"

                                                PrincipledMaterial {
                                                    id: door_lf_0_material
                                                    baseColor: "#ff131313"
                                                    metalness: 0
                                                    roughness: 1
                                                    cullMode: Material.NoCulling
                                                }
                                                materials: [
                                                    door_lf_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_door_lf_5_0_195

                                            Model {
                                                id: object_301
                                                source: "meshes/object_301.mesh"

                                                PrincipledMaterial {
                                                    id: door_lf_5_material
                                                    baseColor: "#ff0b0b0b"
                                                    metalness: 0
                                                    roughness: 1
                                                    cullMode: Material.NoCulling
                                                }
                                                materials: [
                                                    door_lf_5_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_glass_0_0_196

                                            Model {
                                                id: object_303
                                                source: "meshes/object_303.mesh"
                                                materials: [
                                                    glass_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_mirror_inside_0_0_197

                                            Model {
                                                id: object_305
                                                source: "meshes/object_305.mesh"
                                                materials: [
                                                    mirror_inside_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_primary_0_198

                                            Model {
                                                id: object_307
                                                source: "meshes/object_307.mesh"
                                                materials: [
                                                    primary_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_primary_002_0_199

                                            Model {
                                                id: object_309
                                                source: "meshes/object_309.mesh"

                                                PrincipledMaterial {
                                                    id: primary_002_material
                                                    baseColorMap: Texture {
                                                        source: "maps/primary.002_baseColor.png"
                                                        tilingModeHorizontal: Texture.Repeat
                                                        tilingModeVertical: Texture.Repeat
                                                    }
                                                    opacityChannel: Material.A
                                                    metalness: 0
                                                    roughness: 1
                                                    cullMode: Material.NoCulling
                                                }
                                                materials: [
                                                    primary_002_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lf_ok_200

                                            Node {
                                                id: door_lf_ok_primary_0_201

                                                Model {
                                                    id: object_312
                                                    source: "meshes/object_312.mesh"
                                                    materials: [
                                                        primary_material
                                                    ]
                                                }
                                            }
                                        }
                                    }
                                }

                                Node {
                                    id: door_lr_dummy_202
                                    x: -1.03329
                                    y: -0.13056
                                    z: -0.0625833
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: door_lr_203
                                        x: 5.84126e-06
                                        y: 7.59959e-07
                                        z: -5.58794e-07
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: door_lr_JUST_BLACK_0_0_204

                                            Model {
                                                id: object_316
                                                source: "meshes/object_316.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_texture_Buttons_0_0_205

                                            Model {
                                                id: object_318
                                                source: "meshes/object_318.mesh"
                                                materials: [
                                                    texture_Buttons_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_primary_004_0_206

                                            Model {
                                                id: object_320
                                                source: "meshes/object_320.mesh"

                                                PrincipledMaterial {
                                                    id: primary_004_material
                                                    baseColor: "#ff3cff00"
                                                    metalness: 0
                                                    roughness: 1
                                                    cullMode: Material.NoCulling
                                                }
                                                materials: [
                                                    primary_004_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_movsteer_1_0_1_0_207

                                            Model {
                                                id: object_322
                                                source: "meshes/object_322.mesh"
                                                materials: [
                                                    movsteer_1_0_1_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_movsteer_1_0_0_0_208

                                            Model {
                                                id: object_324
                                                source: "meshes/object_324.mesh"
                                                materials: [
                                                    movsteer_1_0_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_Putih_0_0_209

                                            Model {
                                                id: object_326
                                                source: "meshes/object_326.mesh"
                                                materials: [
                                                    putih_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_Plastic_0_0_210

                                            Model {
                                                id: object_328
                                                source: "meshes/object_328.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_aluminium2_0_0_211

                                            Model {
                                                id: object_330
                                                source: "meshes/object_330.mesh"
                                                materials: [
                                                    aluminium_light_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_dvorright_0_0_212

                                            Model {
                                                id: object_332
                                                source: "meshes/object_332.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_glass_0_0_213

                                            Model {
                                                id: object_334
                                                source: "meshes/object_334.mesh"
                                                materials: [
                                                    glass_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_primary_0_214

                                            Model {
                                                id: object_336
                                                source: "meshes/object_336.mesh"
                                                materials: [
                                                    primary_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_primary_002_0_215

                                            Model {
                                                id: object_338
                                                source: "meshes/object_338.mesh"
                                                materials: [
                                                    primary_002_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_lr_ok_216

                                            Node {
                                                id: door_lr_ok_primary_0_217

                                                Model {
                                                    id: object_341
                                                    source: "meshes/object_341.mesh"
                                                    materials: [
                                                        primary_material
                                                    ]
                                                }
                                            }
                                        }
                                    }
                                }

                                Node {
                                    id: door_rf_dummy_218
                                    x: 1.00579
                                    y: 1.17528
                                    z: -0.0625812
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: door_rf_219
                                        x: -2.38419e-07
                                        y: -4.17233e-06
                                        z: 6.93649e-06
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: door_rf_JUST_BLACK_0_0_220

                                            Model {
                                                id: object_345
                                                source: "meshes/object_345.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_texture_Buttons_0_0_221

                                            Model {
                                                id: object_347
                                                source: "meshes/object_347.mesh"
                                                materials: [
                                                    texture_Buttons_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_movsteer_1_0_1_0_222

                                            Model {
                                                id: object_349
                                                source: "meshes/object_349.mesh"
                                                materials: [
                                                    movsteer_1_0_1_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_movsteer_1_0_0_0_223

                                            Model {
                                                id: object_351
                                                source: "meshes/object_351.mesh"
                                                materials: [
                                                    movsteer_1_0_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_Putih_0_0_224

                                            Model {
                                                id: object_353
                                                source: "meshes/object_353.mesh"
                                                materials: [
                                                    putih_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_Plastic_0_0_225

                                            Model {
                                                id: object_355
                                                source: "meshes/object_355.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_aluminium2_0_0_226

                                            Model {
                                                id: object_357
                                                source: "meshes/object_357.mesh"
                                                materials: [
                                                    aluminium_light_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_dvorright_0_0_227

                                            Model {
                                                id: object_359
                                                source: "meshes/object_359.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_door_lf_0_0_228

                                            Model {
                                                id: object_361
                                                source: "meshes/object_361.mesh"
                                                materials: [
                                                    door_lf_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_glass_0_0_229

                                            Model {
                                                id: object_363
                                                source: "meshes/object_363.mesh"
                                                materials: [
                                                    glass_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_mirror_inside_0_0_230

                                            Model {
                                                id: object_365
                                                source: "meshes/object_365.mesh"
                                                materials: [
                                                    mirror_inside_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_primary_0_231

                                            Model {
                                                id: object_367
                                                source: "meshes/object_367.mesh"
                                                materials: [
                                                    primary_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_primary_002_0_232

                                            Model {
                                                id: object_369
                                                source: "meshes/object_369.mesh"
                                                materials: [
                                                    primary_002_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rf_ok_233

                                            Node {
                                                id: door_rf_ok_primary_0_234

                                                Model {
                                                    id: object_372
                                                    source: "meshes/object_372.mesh"
                                                    materials: [
                                                        primary_material
                                                    ]
                                                }
                                            }
                                        }
                                    }
                                }

                                Node {
                                    id: door_rr_dummy_235
                                    x: 1.03309
                                    y: -0.13056
                                    z: -0.0625833
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: door_rr_236
                                        x: 5.96046e-07
                                        y: 5.21541e-07
                                        z: -5.58794e-07
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: door_rr_JUST_BLACK_0_0_237

                                            Model {
                                                id: object_376
                                                source: "meshes/object_376.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_texture_Buttons_0_0_238

                                            Model {
                                                id: object_378
                                                source: "meshes/object_378.mesh"
                                                materials: [
                                                    texture_Buttons_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_movsteer_1_0_1_0_239

                                            Model {
                                                id: object_380
                                                source: "meshes/object_380.mesh"
                                                materials: [
                                                    movsteer_1_0_1_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_movsteer_1_0_0_0_240

                                            Model {
                                                id: object_382
                                                source: "meshes/object_382.mesh"
                                                materials: [
                                                    movsteer_1_0_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_Putih_0_0_241

                                            Model {
                                                id: object_384
                                                source: "meshes/object_384.mesh"
                                                materials: [
                                                    putih_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_Plastic_0_0_242

                                            Model {
                                                id: object_386
                                                source: "meshes/object_386.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_aluminium2_0_0_243

                                            Model {
                                                id: object_388
                                                source: "meshes/object_388.mesh"
                                                materials: [
                                                    aluminium_light_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_dvorright_0_0_244

                                            Model {
                                                id: object_390
                                                source: "meshes/object_390.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_glass_0_0_245

                                            Model {
                                                id: object_392
                                                source: "meshes/object_392.mesh"
                                                materials: [
                                                    glass_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_primary_0_246

                                            Model {
                                                id: object_394
                                                source: "meshes/object_394.mesh"
                                                materials: [
                                                    primary_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_primary_002_0_247

                                            Model {
                                                id: object_396
                                                source: "meshes/object_396.mesh"
                                                materials: [
                                                    primary_002_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: door_rr_ok_248
                                            z: 0.000274837

                                            Node {
                                                id: door_rr_ok_primary_002_0_249

                                                Model {
                                                    id: object_399
                                                    source: "meshes/object_399.mesh"
                                                    materials: [
                                                        primary_002_material
                                                    ]
                                                }
                                            }
                                        }
                                    }
                                }

                                Node {
                                    id: windscreen_dummy_250
                                    y: 0.729028
                                    z: 0.572526
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: windscreen_ok_251
                                        y: 1.2517e-06
                                        z: -1.78814e-06
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: windscreen_ok_glass_0_0_252

                                            Model {
                                                id: object_403
                                                source: "meshes/object_403.mesh"
                                                materials: [
                                                    glass_0_material
                                                ]
                                            }
                                        }
                                    }
                                }

                                Node {
                                    id: bump_front_dummy_253
                                    x: 0.87334
                                    y: 1.93141
                                    z: 0.128491
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: front_black_254
                                        x: 4.73857e-05
                                        y: -1.19209e-07
                                        z: -1.93715e-07
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: front_black_front_black_0_0_255

                                            Model {
                                                id: object_407
                                                source: "meshes/object_407.mesh"
                                                materials: [
                                                    dvorright_0_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: chrome_002_256

                                            Node {
                                                id: chrome_002_back_chrome_light_0_0_257

                                                Model {
                                                    id: object_410
                                                    source: "meshes/object_410.mesh"
                                                    materials: [
                                                        back_chrome_light_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: foglights_r_258

                                            Node {
                                                id: foglights_r_foglight_r_0_259

                                                Model {
                                                    id: object_413
                                                    source: "meshes/object_413.mesh"
                                                    materials: [
                                                        breaklight_l_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: foglights_l_260

                                            Node {
                                                id: foglights_l_foglight_l_0_261

                                                Model {
                                                    id: object_416
                                                    source: "meshes/object_416.mesh"
                                                    materials: [
                                                        breaklight_l_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: indicator_lights_r_262

                                            Node {
                                                id: indicator_lights_r_indicator_rf_0_263

                                                Model {
                                                    id: object_419
                                                    source: "meshes/object_419.mesh"
                                                    materials: [
                                                        right_rear_light_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: indicator_lights_l_264

                                            Node {
                                                id: indicator_lights_l_indicator_lf_0_265

                                                Model {
                                                    id: object_422
                                                    source: "meshes/object_422.mesh"
                                                    materials: [
                                                        right_rear_light_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: tembus_depan_ok_266

                                            Node {
                                                id: tembus_depan_ok_tembus_red_0_0_267

                                                Model {
                                                    id: object_425
                                                    source: "meshes/object_425.mesh"
                                                    materials: [
                                                        tembus_red_0_material
                                                    ]
                                                }
                                            }
                                        }
                                    }

                                    Node {
                                        id: front_bumper_ok_268
                                        x: 2.29478e-05
                                        y: 1.0848e-05
                                        z: 2.72244e-05
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: front_bumper_ok_primary_0_269

                                            Model {
                                                id: object_428
                                                source: "meshes/object_428.mesh"
                                                materials: [
                                                    primary_material
                                                ]
                                            }
                                        }
                                    }
                                }

                                Node {
                                    id: bump_rear_dummy_270
                                    x: 0.87334
                                    y: -1.92876
                                    z: 0.281369
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: rear_bumper_271
                                        x: -2.14577e-06
                                        y: -5.96046e-07
                                        z: 1.51992e-05
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: rear_bumper_movsteer_1_0_1_0_272

                                            Model {
                                                id: object_432
                                                source: "meshes/object_432.mesh"
                                                materials: [
                                                    movsteer_1_0_1_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: rear_bumper_ok_273
                                            x: 2.77162e-05
                                            y: 1.38283e-05
                                            z: -1.508e-05

                                            Node {
                                                id: rear_bumper_ok_primary_0_274

                                                Model {
                                                    id: object_435
                                                    source: "meshes/object_435.mesh"
                                                    materials: [
                                                        primary_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: light_pantulan_275

                                            Node {
                                                id: light_pantulan_light_pantulan_0_0_276

                                                Model {
                                                    id: object_438
                                                    source: "meshes/object_438.mesh"

                                                    PrincipledMaterial {
                                                        id: light_pantulan_0_material
                                                        baseColorMap: Texture {
                                                            source: "maps/light_pantulan.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        opacityChannel: Material.A
                                                        metalness: 0
                                                        roughness: 1
                                                        emissiveMap: Texture {
                                                            source: "maps/light_pantulan.0_baseColor.png"
                                                            tilingModeHorizontal: Texture.Repeat
                                                            tilingModeVertical: Texture.Repeat
                                                        }
                                                        emissiveColor: "#ffffffff"
                                                        cullMode: Material.NoCulling
                                                    }
                                                    materials: [
                                                        light_pantulan_0_material
                                                    ]
                                                }
                                            }
                                        }

                                        Node {
                                            id: tembus_belakang_277

                                            Node {
                                                id: tembus_belakang_tembus_red_0_0_278

                                                Model {
                                                    id: object_441
                                                    source: "meshes/object_441.mesh"
                                                    materials: [
                                                        tembus_red_0_material
                                                    ]
                                                }
                                            }
                                        }
                                    }
                                }

                                Node {
                                    id: bonnet_dummy_279
                                    y: 1.32639
                                    z: 0.237391
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: bonnet_ok_280
                                        y: -9.53674e-07
                                        z: 1.0103e-05
                                        eulerRotation.x: -1.51661e-21

                                        Node {
                                            id: bonnet_ok_primary_0_281

                                            Model {
                                                id: object_445
                                                source: "meshes/object_445.mesh"
                                                materials: [
                                                    primary_material
                                                ]
                                            }
                                        }

                                        Node {
                                            id: chrome_bonnet_ok_282
                                            y: -4.76837e-07
                                            z: -2.38419e-07

                                            Node {
                                                id: chrome_bonnet_ok_movsteer_1_0_1_0_283

                                                Model {
                                                    id: object_448
                                                    source: "meshes/object_448.mesh"
                                                    materials: [
                                                        movsteer_1_0_1_material
                                                    ]
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Node {
                                id: wheel_rf_dummy_284
                                x: 0.925074
                                y: 1.75662
                                z: -0.37177
                                eulerRotation.x: -1.51661e-21

                                Node {
                                    id: wheels_285
                                    x: -7.22408e-05
                                    y: 3.61204e-05
                                    z: 2.49147e-05
                                    eulerRotation.x: -1.51661e-21

                                    Node {
                                        id: wheels_wheels_2_0_286

                                        Model {
                                            id: object_452
                                            source: "meshes/object_452.mesh"

                                            PrincipledMaterial {
                                                id: wheels_2_material
                                                baseColorMap: Texture {
                                                    source: "maps/wheels.2_baseColor.png"
                                                    tilingModeHorizontal: Texture.Repeat
                                                    tilingModeVertical: Texture.Repeat
                                                }
                                                opacityChannel: Material.A
                                                metalness: 0
                                                roughness: 1
                                                cullMode: Material.NoCulling
                                            }
                                            materials: [
                                                wheels_2_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_wheels_0_0_287

                                        Model {
                                            id: object_454
                                            source: "meshes/object_454.mesh"

                                            PrincipledMaterial {
                                                id: wheels_0_material
                                                baseColorMap: Texture {
                                                    source: "maps/movsteer_1.0.1_baseColor.png"
                                                    tilingModeHorizontal: Texture.Repeat
                                                    tilingModeVertical: Texture.Repeat
                                                }
                                                opacityChannel: Material.A
                                                metalness: 0
                                                roughness: 0.823502
                                                cullMode: Material.NoCulling
                                            }
                                            materials: [
                                                wheels_0_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_wheels_1_0_288

                                        Model {
                                            id: object_456
                                            source: "meshes/object_456.mesh"
                                            materials: [
                                                dvorright_0_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_movsteer_1_0_1_0_289

                                        Model {
                                            id: object_458
                                            source: "meshes/object_458.mesh"
                                            materials: [
                                                movsteer_1_0_1_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_wheels_3_0_290

                                        Model {
                                            id: object_460
                                            source: "meshes/object_460.mesh"

                                            PrincipledMaterial {
                                                id: wheels_3_material
                                                baseColorMap: Texture {
                                                    source: "maps/wheels.3_baseColor.png"
                                                    tilingModeHorizontal: Texture.Repeat
                                                    tilingModeVertical: Texture.Repeat
                                                }
                                                opacityChannel: Material.A
                                                metalness: 0
                                                roughness: 1
                                                cullMode: Material.NoCulling
                                            }
                                            materials: [
                                                wheels_3_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_wheels_4_0_291

                                        Model {
                                            id: object_462
                                            source: "meshes/object_462.mesh"

                                            PrincipledMaterial {
                                                id: wheels_4_material
                                                baseColorMap: Texture {
                                                    source: "maps/wheels.4_baseColor.png"
                                                    tilingModeHorizontal: Texture.Repeat
                                                    tilingModeVertical: Texture.Repeat
                                                }
                                                opacityChannel: Material.A
                                                metalness: 0
                                                roughness: 1
                                                cullMode: Material.NoCulling
                                            }
                                            materials: [
                                                wheels_4_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_wheels_6_0_292

                                        Model {
                                            id: object_464
                                            source: "meshes/object_464.mesh"

                                            PrincipledMaterial {
                                                id: wheels_6_material
                                                baseColorMap: Texture {
                                                    source: "maps/wheels.6_baseColor.png"
                                                    tilingModeHorizontal: Texture.Repeat
                                                    tilingModeVertical: Texture.Repeat
                                                }
                                                opacityChannel: Material.A
                                                metalness: 0
                                                roughness: 0.683772
                                                cullMode: Material.NoCulling
                                            }
                                            materials: [
                                                wheels_6_material
                                            ]
                                        }
                                    }
                                }

                                Node {
                                    id: wheels_001_293
                                    x: -7.22408e-05
                                    y: -3.20398
                                    z: 2.49147e-05
                                    eulerRotation.x: -1.48969e-21
                                    scale.x: 1.01807
                                    scale.y: 1.01807
                                    scale.z: 1.01807

                                    Node {
                                        id: wheels_001_wheels_2_0_294

                                        Model {
                                            id: object_467
                                            source: "meshes/object_467.mesh"
                                            materials: [
                                                wheels_2_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_001_wheels_0_0_295

                                        Model {
                                            id: object_469
                                            source: "meshes/object_469.mesh"
                                            materials: [
                                                wheels_0_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_001_wheels_1_0_296

                                        Model {
                                            id: object_471
                                            source: "meshes/object_471.mesh"
                                            materials: [
                                                dvorright_0_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_001_movsteer_1_0_1_0_297

                                        Model {
                                            id: object_473
                                            source: "meshes/object_473.mesh"
                                            materials: [
                                                movsteer_1_0_1_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_001_wheels_3_0_298

                                        Model {
                                            id: object_475
                                            source: "meshes/object_475.mesh"
                                            materials: [
                                                wheels_3_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_001_wheels_4_0_299

                                        Model {
                                            id: object_477
                                            source: "meshes/object_477.mesh"
                                            materials: [
                                                wheels_4_material
                                            ]
                                        }
                                    }

                                    Node {
                                        id: wheels_001_wheels_6_0_300

                                        Model {
                                            id: object_479
                                            source: "meshes/object_479.mesh"
                                            materials: [
                                                wheels_6_material
                                            ]
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
