extends Node3D

signal was_pulled

@onready var interactable: Interactable = $Interactable
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_pulled := false


func _ready() -> void:
    interactable.was_interacted_with.connect(on_interact)
    interactable.was_pondered_while_holding.connect(on_ponder)


func pull_lever() -> void:
    is_pulled = true
    animation_player.play("PullLever")
    await animation_player.animation_finished
    was_pulled.emit()
    await get_tree().create_timer(1).timeout
    animation_player.play("ResetLever")
    await animation_player.animation_finished
    is_pulled = false


func on_ponder(held_item: Holdable) -> void:
    if not is_pulled:
        GameEvents.emit_update_prompt("Pull Lever")
        return

    GameEvents.emit_update_prompt("")


func on_interact(held_item: Holdable) -> void:
    if not is_pulled:
        pull_lever()
