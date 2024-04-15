extends AudioStreamPlayer

@export var footstep_sounds: AudioStreamRandomizer

@onready var start_timer: Timer = $StartTimer
@onready var next_step_timer: Timer = $NextStepTimer

var is_stepping := false
var playback_pitch_scale := 1.0


func _ready() -> void:
    finished.connect(on_audio_finished)
    start_timer.timeout.connect(on_start_timer_timeout)
    next_step_timer.timeout.connect(on_next_step_timer_timeout)


func set_sprint_speed() -> void:
    playback_pitch_scale = 1.5
    next_step_timer.wait_time = 0.05


func set_walk_speed() -> void:
    playback_pitch_scale = 1
    next_step_timer.wait_time = 0.8


func start_footsteps() -> void:
    if is_stepping:
        return
    is_stepping = true
    if start_timer.is_stopped():
        start_timer.start()


func stop_footsteps() -> void:
    is_stepping = false


func play_footstep() -> void:
    #if playing:
        #return
    get_stream_playback().play_stream(footstep_sounds, 0, 0, playback_pitch_scale)
    next_step_timer.start()


func on_audio_finished() -> void:
    pass
    #if not is_stepping:
        #return
    #play_footstep()
    #next_step_timer.start()


func on_next_step_timer_timeout() -> void:
    if not is_stepping:
        return
    play_footstep()
    next_step_timer.start()


func on_start_timer_timeout() -> void:
    if not is_stepping:
        return
    play_footstep()

