extends CanvasLayer
@onready var dialogue: Control = %Dialogue

var test_dialogue: Array[String] = [
    "MWAHAHAHAHELLO",
    "Time for your examination...",
    "Buckle up kiddo",
    "It's gonna be fuckin CRAZY",
    "You're gonna summon the SHIT outta this spooky town tonight!!!",
    "glhf",
]

func _ready() -> void:
    Input.set_use_accumulated_input(false)
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    get_tree().paused =  true
    await $GUI.show_dialogue(test_dialogue)
    get_tree().paused = false

func _unhandled_input(event):
    $SubViewport.push_input(event)
