extends CanvasLayer

const STARTING_GAME_TEXT = "Starting game in %d..."

@onready var label: Label = %Label
@onready var button: Button = %Button


func _ready() -> void:
    button.pressed.connect(on_button_pressed)

    # TODO: for now just go straight to the game.
    get_tree().call_deferred("change_scene_to_file", "res://scenes/main/main.tscn")


func on_button_pressed() -> void:
    label.text = STARTING_GAME_TEXT % 3
    await get_tree().create_timer(0.5).timeout
    label.text = STARTING_GAME_TEXT % 2
    await get_tree().create_timer(0.5).timeout
    label.text = STARTING_GAME_TEXT % 1
    await get_tree().create_timer(0.5).timeout
    get_tree().change_scene_to_file("res://scenes/main/main.tscn")
