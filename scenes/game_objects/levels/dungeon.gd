extends Node3D

@export var player_scene: PackedScene
@onready var spawn_point: Marker3D = $SpawnPoint

@export_range (0.0, 1.0) var maze_hurry_up_start_time: float = 0.75
@onready var maze_timer: Timer = %MazeTimer
@onready var maze_gate: StaticBody3D = %MazeGate
@onready var maze_front_lever: Node3D = %MazeFrontLever
@onready var maze_back_lever: Node3D = %MazeBackLever
@onready var maze_back_gate: StaticBody3D = %MazeBackGate
@onready var maze_time_tick_animation_player: AnimationPlayer = $MazeTimeTickAnimationPlayer
var maze_puzzle_complete := false
var maze_hurry_up_timer: Timer

@onready var small_room_gate: StaticBody3D = %SmallRoomGate
@onready var small_room_lever: Node3D = %SmallRoomLever
var small_room_puzzle_complete := false

@onready var moving_platform_lever: Node3D = %MovingPlatformLever
@onready var moving_platform_animation_player: AnimationPlayer = %MovingPlatformAnimationPlayer

@onready var ritual_book: Node3D = %RitualBook
@onready var dungeon_model: Node3D = %DungeonModel
@onready var summoning_light: SpotLight3D = %SummoningLight
@onready var summoning_particles: GPUParticles3D = %SummoningParticles

@onready var end_audio_player: AudioStreamPlayer3D = $EndAudioPlayer

func _ready() -> void:
    maze_timer.timeout.connect(on_maze_timer_timeout)
    maze_front_lever.was_pulled.connect(on_maze_front_lever_pulled)
    maze_back_lever.was_pulled.connect(on_maze_back_lever_pulled)
    small_room_lever.was_pulled.connect(on_small_room_lever_pulled)
    moving_platform_lever.was_pulled.connect(on_moving_platform_lever_pulled)

    maze_hurry_up_timer = maze_timer.duplicate()
    add_child(maze_hurry_up_timer)
    maze_hurry_up_timer.wait_time *= maze_hurry_up_start_time
    maze_hurry_up_timer.timeout.connect(on_maze_hurry_up_timer_timeout)

    ritual_book.final_boss_summoned.connect(on_final_boss_summoned)

    var player := player_scene.instantiate() as Player
    add_child(player)
    player.global_position = spawn_point.global_position
    player.rotate_object_local(Vector3.UP, -PI/2.5)

    #TODO: debugging
    player.global_position = $DebugSpawn.global_position


func on_maze_timer_timeout() -> void:
    maze_time_tick_animation_player.play("RESET")
    maze_gate.close()


func on_maze_hurry_up_timer_timeout() -> void:
    maze_time_tick_animation_player.speed_scale = 2


func on_maze_front_lever_pulled() -> void:
    if not maze_puzzle_complete:
        maze_gate.open()
        maze_time_tick_animation_player.speed_scale = 1
        maze_timer.start()
        maze_hurry_up_timer.start()
        maze_time_tick_animation_player.play("time_tick")


func on_maze_back_lever_pulled() -> void:
    if not maze_puzzle_complete:
        maze_puzzle_complete = true
        maze_back_gate.open()


func on_small_room_lever_pulled() -> void:
    if not small_room_puzzle_complete:
        small_room_puzzle_complete = true
        small_room_gate.open()


func on_moving_platform_lever_pulled() -> void:
    if not moving_platform_animation_player.is_playing():
        moving_platform_animation_player.play("move")



func on_final_boss_summoned() -> void:
    dungeon_model.start_summon()
    summoning_light.visible = true
    summoning_particles.emitting = true
    end_audio_player.play()
    await get_tree().create_timer(end_audio_player.stream.get_length()-3.5).timeout
    GameEvents.emit_finished_game()
