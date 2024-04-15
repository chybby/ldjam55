extends Node3D


@onready var interactable: Interactable = %Interactable
@onready var holdable: Holdable = %Holdable


func _ready() -> void:
    interactable.was_interacted_with.connect(on_interact)
    interactable.was_pondered_while_holding.connect(on_ponder)


func on_ponder(held_item: Holdable) -> void:
    if held_item == null:
        GameEvents.emit_update_prompt("Pick up " + name)
    elif held_item != holdable:
        GameEvents.emit_update_prompt("Swap %s with %s" % [held_item.owner.name, name])


func on_interact(held_item: Holdable) -> void:
    holdable.pick_up()
