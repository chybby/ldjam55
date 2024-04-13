extends CharacterBody3D

@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s") var max_speed: float = 10.0
@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s") var fall_acceleration: float = 1.0
@export_range(0.0, 100.0, 0.1, "or_greater") var mouse_sensitivity: float = 0.003

@onready var health: Health = $Health
@onready var camera: Camera3D = $Camera3D

var target_velocity := Vector3.ZERO
var mouse_input := Vector2.ZERO

func _ready() -> void:
    health.died.connect(on_died)

func _unhandled_input(event: InputEvent) -> void:
    if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        if event is InputEventMouseMotion:
            var viewport_transform := get_tree().root.get_final_transform()
            mouse_input += event.xformed_by(viewport_transform).relative
        elif event is InputEventKey:
            if event.is_action_pressed("escape"):
                Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    else:
        if event is InputEventMouseButton:
            if event.button_index == 1:
                Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
    # Looking around.
    rotate_object_local(Vector3.DOWN, mouse_input.x * mouse_sensitivity)
    orthonormalize()

    camera.rotate_object_local(Vector3.LEFT, mouse_input.y * mouse_sensitivity)
    camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
    camera.orthonormalize()

    mouse_input = Vector2.ZERO

    # Moving.
    var ground_velocity := get_movement_input()
    target_velocity.x = ground_velocity.x * max_speed
    target_velocity.z = ground_velocity.y * max_speed

    target_velocity = target_velocity.rotated(Vector3.UP, rotation.y)

    if not is_on_floor():
        target_velocity.y -= (fall_acceleration * delta)

    velocity = target_velocity
    move_and_slide()


func get_movement_input() -> Vector2:
    return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")


func on_died() -> void:
    queue_free()
