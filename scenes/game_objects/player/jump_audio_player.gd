extends AudioStreamPlayer

@export var jump_sounds: Array[AudioStream]


func play_jump() -> void:
    stream = jump_sounds.pick_random()
    play()
