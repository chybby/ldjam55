extends Node3D


@onready var animation_player_1: AnimationPlayer = %AnimationPlayer1
@onready var animation_player_2: AnimationPlayer = %AnimationPlayer2
@onready var animation_player_3: AnimationPlayer = %AnimationPlayer3
@onready var animation_player_4: AnimationPlayer = %AnimationPlayer4
@onready var animation_player_5: AnimationPlayer = %AnimationPlayer5
@onready var animation_player_6: AnimationPlayer = %AnimationPlayer6
@onready var animation_player_7: AnimationPlayer = %AnimationPlayer7


func start_summon() -> void:
    animation_player_1.play("Armature_001Action ")
    animation_player_2.play("Armature_001Action_001 ")
    animation_player_3.play("Armature_002Action ")
    animation_player_4.play("Armature_002Action_001 ")
    animation_player_5.play("Armature_003Action ")
    animation_player_6.play("Armature_003Action_001 ")
    animation_player_7.play("TentaclesAction")
