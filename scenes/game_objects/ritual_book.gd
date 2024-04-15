extends Node3D

signal final_boss_summoned


@onready var interactable: Interactable = %Interactable
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


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
        final_boss_summoned.emit()
    else:
        audio_stream_player.play()
