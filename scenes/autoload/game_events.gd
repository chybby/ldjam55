extends Node

signal started_game
signal update_prompt(prompt)
signal finished_game


func emit_started_game() -> void:
    started_game.emit()


func emit_update_prompt(prompt: String) -> void:
    update_prompt.emit(prompt)


func emit_finished_game() -> void:
    finished_game.emit()
