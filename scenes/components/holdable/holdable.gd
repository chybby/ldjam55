class_name Holdable
extends Node

signal was_picked_up
signal was_dropped


func pick_up() -> void:
    var player = get_tree().get_first_node_in_group("player") as Player
    player.pick_up(self)
    was_picked_up.emit()


func drop() -> void:
    was_dropped.emit()
