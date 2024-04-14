extends Control

signal dismissed

func _input(event: InputEvent) -> void:
    if visible:
        accept_event()
        if event.is_action_pressed("progress"):
            visible = false
            dismissed.emit()
