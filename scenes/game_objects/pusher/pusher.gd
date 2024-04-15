extends Node3D

@export var initial_delay := 0.0

@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
    await get_tree().create_timer(initial_delay).timeout
    animation_player.play("push")
