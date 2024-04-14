extends Control

signal next_dialogue

@export var pp_bob_speed: Vector2 = Vector2(1.0, 2.5)
@export var pp_bob_amplitude: Vector2 = Vector2(0.125, 0.063)

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var speech_text: Label = %SpeechText
@onready var profile_picture: TextureRect = %ProfilePicture


func _ready():
    profile_picture.material.set_shader_parameter("bob_speed", pp_bob_speed)
    profile_picture.material.set_shader_parameter("bob_amplitude", pp_bob_amplitude)
    profile_picture.material.set_shader_parameter("texture_size", profile_picture.size)


func _input(event):
    if visible:
        accept_event()
        if event.is_action_pressed("next_dialogue"):
            progress_dialogue()


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
