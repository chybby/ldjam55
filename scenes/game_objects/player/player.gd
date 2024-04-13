extends CharacterBody3D

@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s") var walk_speed: float = 3.0
@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s") var sprint_speed: float = 6.0
@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s") var jump_strength: float = 5.0
@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s^2") var fall_acceleration: float = 10.0
@export_range(0.0, 100.0, 0.1, "or_greater") var mouse_sensitivity: float = 0.003

@onready var health: Health = $Health
@onready var camera: Camera3D = $Camera3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_ray: RayCast3D = $Camera3D/InteractRay
@onready var held_item_marker: Marker3D = $HeldItemMarker


var target_velocity := Vector3.ZERO
var mouse_input := Vector2.ZERO

var held_item : StaticBody3D = null


func _ready() -> void:
    health.died.connect(on_died)
    interact_ray.interactable_changed.connect(on_interactable_changed)


func _unhandled_input(event: InputEvent) -> void:
    if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        if event is InputEventMouseMotion:
            handle_captured_mouse_motion(event)
        elif event is InputEventKey:
            if event.is_action_pressed("escape"):
                Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
            if event.is_action_pressed("interact") and interact_ray.interactable != null:
                interact(interact_ray.interactable)
    else:
        if event is InputEventMouseButton:
            if event.button_index == 1:
                Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
    # Looking around.
    rotate_object_local(Vector3.DOWN, mouse_input.x * mouse_sensitivity)
    orthonormalize()

    camera.rotate_object_local(Vector3.LEFT, mouse_input.y * mouse_sensitivity)
    camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -80, 80)
    camera.orthonormalize()

    mouse_input = Vector2.ZERO

    # Moving.
    var speed := walk_speed
    animation_player.speed_scale = 1

    var ground_velocity := get_movement_input()

    if Input.is_action_pressed("sprint") and !ground_velocity.is_zero_approx():
        speed = sprint_speed
        animation_player.speed_scale = sprint_speed/walk_speed

    if !ground_velocity.is_zero_approx():
        target_velocity.x = ground_velocity.x * speed
        target_velocity.z = ground_velocity.y * speed
        animation_player.play("walk_bob")
    else:
        target_velocity.x = 0
        target_velocity.z = 0
        animation_player.play("idle", 3)

    target_velocity = target_velocity.rotated(Vector3.UP, rotation.y)

    if not is_on_floor():
        target_velocity.y -= (fall_acceleration * delta)
        animation_player.play("RESET", 2)
    else:
        target_velocity.y = 0
        if Input.is_action_just_pressed("jump"):
            target_velocity.y = jump_strength

    velocity = target_velocity
    move_and_slide()


func handle_captured_mouse_motion(event: InputEventMouseMotion) -> void:
    var viewport_transform := get_tree().root.get_final_transform()
    mouse_input += event.xformed_by(viewport_transform).relative


func interact(interactable: Interactable) -> void:
    print("interacted with ", interactable)
    if interactable.is_pickup:
        var new_item = interactable.owner as StaticBody3D

        if held_item != null:
            held_item.reparent(get_parent())
            held_item.position = new_item.position
            held_item.set_collision_layer_value(1, true)

        held_item = new_item
        new_item.reparent(held_item_marker)
        new_item.position = Vector3.ZERO
        new_item.set_collision_layer_value(1, false)


func on_interactable_changed(interactable: Interactable) -> void:
    # TODO: show prompt on HUD.
    print(interactable)


func get_movement_input() -> Vector2:
    return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")


func on_died() -> void:
    # TODO: respawn.
    queue_free()
