class_name Holdable
extends Node

signal was_picked_up(player: Player)
signal was_dropped(player: Player)


func pick_up() -> void:
    var player = get_tree().get_first_node_in_group("player") as Player
    player.pick_up(self)
    was_picked_up.emit(player)


func drop() -> void:
    var player = get_tree().get_first_node_in_group("player") as Player
    was_dropped.emit(player)
