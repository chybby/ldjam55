extends Node3D

@export var player_scene: PackedScene

@onready var spawn_point: Marker3D = $SpawnPoint

func _ready() -> void:
    var player := player_scene.instantiate() as CharacterBody3D
    add_child(player)
    player.global_position = spawn_point.global_position
    player.rotate_object_local(Vector3.UP, -PI/2.5)
