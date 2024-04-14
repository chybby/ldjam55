extends Node

signal update_prompt(prompt)


func emit_update_prompt(prompt: String) -> void:
    update_prompt.emit(prompt)
