extends Control

@onready var game_time: Label = %GameTime

var start_time: int


func _ready() -> void:
    GameEvents.started_game.connect(on_started_game)
    GameEvents.finished_game.connect(on_finished_game)


func on_started_game() -> void:
    start_time = Time.get_ticks_msec()


func on_finished_game() -> void:
    var end_time = Time.get_ticks_msec()

    var total_time = end_time - start_time

    var seconds = total_time / 1000
    var minutes = seconds / 60
    seconds = posmod(seconds, 60)

    game_time.text += "%s:%02s" % [minutes, seconds]
