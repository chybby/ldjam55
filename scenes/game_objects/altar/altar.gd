extends Node3D

@export var being_scene: PackedScene

@onready var interactable: Interactable = %Interactable
@onready var being_marker: Marker3D = %BeingMarker


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
    add_child(being)
    being.position = being_marker.position
