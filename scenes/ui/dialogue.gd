extends Control

signal next_dialogue

@export var pp_bob_speed: Vector2 = Vector2(1.0, 2.5)
@export var pp_bob_amplitude: Vector2 = Vector2(0.125, 0.063)
@export_multiline var dialogue_lines: Array[String]
@export var dialogue_audios: Array[AudioStream]

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var speech_text: Label = %SpeechText
@onready var profile_picture: TextureRect = %ProfilePicture
@onready var speech_audio_player: AudioStreamPlayer = $SpeechAudioPlayer



func _ready():
    profile_picture.material.set_shader_parameter("bob_speed", pp_bob_speed)
    profile_picture.material.set_shader_parameter("bob_amplitude", pp_bob_amplitude)
    profile_picture.material.set_shader_parameter("texture_size", profile_picture.size)


func _input(event):
    if visible:
        accept_event()
        if event.is_action_pressed("next_dialogue"):
            progress_dialogue()


func show_dialogue():
    visible = true
    for i in dialogue_lines.size():
        speech_text.text = dialogue_lines[i]
        if i < dialogue_audios.size():
            speech_audio_player.stream = dialogue_audios[i]
        animation_player.play("scroll_dialogue", -1, 30.0/speech_text.text
        .length())
        await next_dialogue
    animation_player.play("RESET")
    visible = false


func progress_dialogue():
    if animation_player.is_playing():
        animation_player.advance(999)
    else:
        next_dialogue.emit()
