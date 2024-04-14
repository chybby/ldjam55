extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_open := false


func open() -> void:
    animation_player.play("open")
    is_open = true


func close() -> void:
    animation_player.play("close")
    is_open = false
