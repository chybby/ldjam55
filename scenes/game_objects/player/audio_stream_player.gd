extends AudioStreamPlayer

@export var footstep_sounds: Array[AudioStream]

@onready var timer: Timer = $Timer

var is_stepping := false


func _ready() -> void:
    finished.connect(on_audio_finished)
    timer.timeout.connect(on_timer_timeout)

func start_footsteps() -> void:
    is_stepping = true
    if timer.is_stopped():
        timer.start()
    

func stop_footsteps() -> void:
    is_stepping = false
    
    
func play_footstep() -> void:
    if playing:
        return
    stream = footstep_sounds.pick_random()
    pitch_scale = randf_range(0.9, 1.1)
    play()
    
    
func on_audio_finished() -> void:
    if not is_stepping:
        return
    play_footstep()
    

func on_timer_timeout() -> void:
    if not is_stepping:
        return
    play_footstep()
        
        
