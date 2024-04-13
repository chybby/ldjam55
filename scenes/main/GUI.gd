extends Control

@onready var dialogue: Control = %Dialogue
var dialogue_active = false


func _gui_input(event):
    if dialogue_active:
        accept_event()
        if event.is_action_pressed("next_dialogue"):
            %Dialogue.progress_dialogue()
        
func show_dialogue(text: Array[String]) -> void:
    dialogue_active = true
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    await %Dialogue.show_dialogue(text)
    dialogue_active = false
    
