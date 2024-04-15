extends CanvasLayer

@onready var dialogue: Control = %Dialogue
@onready var title: Control = %Title
@onready var end_game: Control = %EndGame
@onready var world_viewport: SubViewport = %WorldViewport


func _ready() -> void:
    GameEvents.finished_game.connect(on_finished_game)

    Input.set_use_accumulated_input(false)

    var sfx_bus_idx = AudioServer.get_bus_index("SFX")
    AudioServer.set_bus_mute(sfx_bus_idx, true)
    await title.dismissed
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    GameEvents.emit_started_game()
    AudioServer.set_bus_mute(sfx_bus_idx, false)

    await dialogue.show_dialogue()


func _unhandled_input(event):
    world_viewport.push_input(event)


func on_finished_game() -> void:
    end_game.visible = true
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
