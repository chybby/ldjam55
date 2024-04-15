extends Node3D


@onready var interactable: Interactable = %Interactable


func _ready() -> void:
    interactable.was_interacted_with.connect(on_interact)
    interactable.was_pondered_while_holding.connect(on_ponder)


func on_ponder(held_item: Holdable) -> void:
    if held_item != null and held_item.owner.name == "Megaphone":
        GameEvents.emit_update_prompt("Read Incantation Through Megaphone")
    else:
        GameEvents.emit_update_prompt("Read Incantation")


func on_interact(held_item: Holdable) -> void:
    if held_item != null and held_item.owner.name == "Megaphone":
        # TODO: final summoning animation
        GameEvents.emit_finished_game()
