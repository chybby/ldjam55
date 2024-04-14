class_name Player
extends CharacterBody3D

@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s") var walk_speed: float = 4.0
@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s") var sprint_speed: float = 4.0
@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s") var jump_strength: float = 5.0
@export_range(0.0, 100.0, 0.1, "or_greater", "suffix:m/s^2") var fall_acceleration: float = 10.0
@export_range(0.0, 100.0, 0.1, "or_greater") var mouse_sensitivity: float = 0.003

@onready var health: Health = %Health
@onready var camera: Camera3D = %Camera3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_ray: RayCast3D = %InteractRay
@onready var held_item_marker: Marker3D = %HeldItemMarker

@onready var scale_pivot: Node3D = %ScalePivot
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D

@onready var glowing_trail: GPUParticles3D = %GlowingTrail


var ground_velocity := Vector2.ZERO
var target_velocity := Vector3.ZERO
var mouse_input := Vector2.ZERO
var jumped := false

var held_item : Holdable = null


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
            elif event.is_action_pressed("interact") and interact_ray.interactable != null:
                interact(interact_ray.interactable)
            elif event.is_action_pressed("jump"):
                jumped = true
            else:
                ground_velocity = get_movement_input()
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

    # TODO: disable sprint for now
    #if Input.is_action_pressed("sprint") and !ground_velocity.is_zero_approx():
        #speed = sprint_speed
        #animation_player.speed_scale = sprint_speed/walk_speed

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
        if jumped:
            target_velocity.y = jump_strength

    jumped = false

    velocity = target_velocity
    move_and_slide()


func set_player_scale(factor: float) -> void:
    var scale_vector = Vector3.ONE * factor
    scale_pivot.scale = scale_vector
    collision_shape_3d.scale = scale_vector


func enable_glow_trail(enabled: bool) -> void:
    glowing_trail.emitting = enabled


func handle_captured_mouse_motion(event: InputEventMouseMotion) -> void:
    var viewport_transform := get_tree().root.get_final_transform()
    mouse_input += event.xformed_by(viewport_transform).relative


func pick_up(holdable: Holdable) -> void:
    if held_item != null:
        held_item.owner.reparent(get_parent())
        held_item.owner.position = holdable.owner.position
        held_item.owner.set_collision_layer_value(1, true)
        held_item.drop()

    held_item = holdable
    held_item.owner.reparent(held_item_marker)
    held_item.owner.position = Vector3.ZERO
    held_item.owner.set_collision_layer_value(1, false)


func interact(interactable: Interactable) -> void:
    interactable.interact(held_item)

    # Update prompt after interaction.
    interactable.ponder(held_item)


func on_interactable_changed(interactable: Interactable) -> void:
    if interactable == null:
        GameEvents.emit_update_prompt("")
    else:
        interactable.ponder(held_item)


func get_movement_input() -> Vector2:
    return Input.get_vector("move_left", "move_right", "move_forward", "move_backward")


func on_died() -> void:
    # TODO: respawn.
    queue_free()
