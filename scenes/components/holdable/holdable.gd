class_name Holdable
extends Node

signal was_picked_up(player: Player)
signal was_dropped(player: Player)

@export var pick_up_audio_stream: AudioStream

@onready var pick_up_audio_player: AudioStreamPlayer = $PickUpAudioPlayer


func _ready() -> void:
    if pick_up_audio_stream != null:
        pick_up_audio_player.stream = pick_up_audio_stream


func pick_up() -> void:
    var player = get_tree().get_first_node_in_group("player") as Player
    player.pick_up(self)
    was_picked_up.emit(player)
    if pick_up_audio_player.stream != null:
        pick_up_audio_player.play()


func drop() -> void:
    var player = get_tree().get_first_node_in_group("player") as Player
    was_dropped.emit(player)
