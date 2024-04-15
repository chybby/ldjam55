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
    var being = being_scene.instantiate()

    being_path_follow.add_child(being)
    (being.interactable as Interactable).set_collision_layer_value(4, false)
    being.home = being_path_follow

    var tween = get_tree().create_tween()
    tween.tween_property(being_path_follow, "progress_ratio", 1, 15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    await tween.finished
    (being.interactable as Interactable).set_collision_layer_value(4, true)
