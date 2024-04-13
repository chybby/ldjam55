extends Control

signal next_dialogue

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var speech_text: Label = %SpeechText


func show_dialogue(dialogue: Array[String]):
    visible = true
    for line in dialogue:
        speech_text.text = line
        animation_player.play("scroll_dialogue", -1, 30.0/line.length())
        await next_dialogue
    visible = false
        

func progress_dialogue():
    if animation_player.is_playing():
        animation_player.advance(999)
    else:
        next_dialogue.emit()
