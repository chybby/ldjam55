extends Node3D

@export var being_scene: PackedScene
@export var being_path_follow: PathFollow3D

@onready var interactable: Interactable = %Interactable
@onready var summoning_particles: GPUParticles3D = %SummoningParticles
@onready var summoning_light: SpotLight3D = %SummoningLight

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

var summoning_started := false


func _ready() -> void:
    interactable.was_interacted_with.connect(on_interact)
    interactable.was_pondered_while_holding.connect(on_ponder)


func on_ponder(held_item: Holdable) -> void:
    if not summoning_started:
        GameEvents.emit_update_prompt("Read Incantation")
        return

    GameEvents.emit_update_prompt("")


func stop_summoning_effects() -> void:
    summoning_light.visible = false
    summoning_particles.emitting = false


func on_interact(held_item: Holdable) -> void:
    summoning_started = true
    audio_stream_player_3d.play()
    var being := being_scene.instantiate() as Node3D

    being_path_follow.add_child(being)
    (being.interactable as Interactable).set_collision_layer_value(4, false)
    if being.has_method("set_home"):
        being.set_home(being_path_follow)

    if being.name != "Avia":
        being.rotate_object_local(Vector3.UP, PI)
    being.position.y -= 1

    summoning_light.visible = true
    summoning_particles.emitting = true

    var tween = get_tree().create_tween()
    tween.tween_property(being, "position", Vector3.ZERO, 5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.tween_interval(2.0)
    tween.tween_callback(stop_summoning_effects)
    tween.tween_property(being_path_follow, "progress_ratio", 1, 30).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    await tween.finished
    (being.interactable as Interactable).set_collision_layer_value(4, true)
