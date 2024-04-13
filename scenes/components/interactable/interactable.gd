class_name Interactable
extends Area3D

@export var is_pickup: bool = false
@export var item_name: String
@export var prompt_map: Dictionary

signal was_interacted_with(item: Interactable)


func get_prompt(held_item: Interactable) -> String:
    if is_pickup:
        if held_item == null:
            return "Pick up " + item_name
        return "Swap %s with %s" % [held_item.item_name, item_name]

    if held_item == null and "default" in prompt_map:
        return prompt_map.get("default")

    if held_item != null and held_item.item_name in prompt_map:
        return prompt_map.get(held_item.item_name)

    return ""


func interact(held_item: Interactable) -> void:
    was_interacted_with.emit(held_item)
