class_name Interactable
extends Area3D

signal was_interacted_with(item: Holdable)
signal was_pondered_while_holding(item: Holdable)


func ponder(held_item: Holdable) -> void:
    was_pondered_while_holding.emit(held_item)


func interact(held_item: Holdable) -> void:
    was_interacted_with.emit(held_item)
