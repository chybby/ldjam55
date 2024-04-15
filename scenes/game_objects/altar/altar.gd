extends Node3D

@export var being_scene: PackedScene
@export var being_path_follow: PathFollow3D

@onready var interactable: Interactable = %Interactable


var summoning_started := false


func _ready() -> void:
    interactable.was_interacted_with.connect(on_interact)
    interactable.was_pondered_while_holding.connect(on_ponder)


func on_ponder(held_item: Holdable) -> void:
    if not summoning_started:
        GameEvents.emit_update_prompt("Read Incantation")
        return

    GameEvents.emit_update_prompt("")


func on_interact(held_item: Holdable) -> void:
    summoning_started = true
    var being := being_scene.instantiate() as Node3D

    being_path_follow.add_child(being)
    (being.interactable as Interactable).set_collision_layer_value(4, false)
    if being.has_method("set_home"):
        being.set_home(being_path_follow)

    being.rotate_object_local(Vector3.UP, PI)
    being.position.y -= 1

    var tween = get_tree().create_tween()
    tween.tween_property(being, "position", Vector3.ZERO, 5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.tween_interval(2.0)
    tween.tween_property(being_path_follow, "progress_ratio", 1, 15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    await tween.finished
    (being.interactable as Interactable).set_collision_layer_value(4, true)
