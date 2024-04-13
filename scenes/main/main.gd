extends Node3D

func _ready() -> void:
    Input.set_use_accumulated_input(false)
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
