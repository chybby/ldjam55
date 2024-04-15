extends StaticBody3D

@onready var interactable: Interactable = $Interactable
@onready var holdable: Holdable = $Holdable

var home: Node3D

var saved_walk_speed: float = 0.0


func _ready() -> void:
    interactable.was_interacted_with.connect(on_interact)
    interactable.was_pondered_while_holding.connect(on_ponder)
    holdable.was_picked_up.connect(on_pick_up)
    holdable.was_dropped.connect(on_drop)


func set_home(new_home: Node3D) -> void:
    home = new_home


func send_home() -> void:
    global_position = home.global_position


func on_ponder(held_item: Holdable) -> void:
    if held_item == null:
        GameEvents.emit_update_prompt("Pick up " + name)
    elif held_item != holdable and held_item.owner.name != "Megaphone":
        GameEvents.emit_update_prompt("Swap %s with %s" % [held_item.owner.name, name])


func on_interact(held_item: Holdable) -> void:
    holdable.pick_up()


func on_pick_up(player: Player) -> void:
    saved_walk_speed = player.walk_speed
    player.walk_speed = 10
    player.footstep_audio_player.set_sprint_speed()


func on_drop(player: Player) -> void:
    player.walk_speed = saved_walk_speed
    if home != null:
        global_position = home.global_position
    player.footstep_audio_player.set_walk_speed()
