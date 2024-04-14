extends Node3D

@export var player_scene: PackedScene
@onready var spawn_point: Marker3D = $SpawnPoint

@onready var maze_timer: Timer = %MazeTimer
@onready var maze_gate: StaticBody3D = %MazeGate
@onready var maze_front_lever: Node3D = %MazeFrontLever
@onready var maze_back_lever: Node3D = %MazeBackLever
@onready var maze_back_gate: StaticBody3D = %MazeBackGate


var maze_puzzle_complete := false


func _ready() -> void:
    maze_timer.timeout.connect(on_maze_timer_timeout)
    maze_front_lever.was_pulled.connect(on_maze_front_lever_pulled)
    maze_back_lever.was_pulled.connect(on_maze_back_lever_pulled)

    var player := player_scene.instantiate() as Player
    add_child(player)
    player.global_position = spawn_point.global_position
    player.rotate_object_local(Vector3.UP, -PI/2.5)

    #TODO: debugging
    player.global_position = $DebugSpawn.global_position


func on_maze_timer_timeout() -> void:
    maze_gate.close()


func on_maze_front_lever_pulled() -> void:
    if not maze_puzzle_complete:
        maze_gate.open()
        maze_timer.start()


func on_maze_back_lever_pulled() -> void:
    if not maze_puzzle_complete:
        maze_puzzle_complete = true
        maze_back_gate.open()

