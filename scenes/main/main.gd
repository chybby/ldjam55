extends CanvasLayer

@onready var dialogue: Control = %Dialogue
@onready var title: Control = $GUI/Title

var test_dialogue: Array[String] = [
    "MWAHAHAHAHELLO",
    #"Time for your examination...",
    #"Buckle up kiddo",
    #"It's gonna be fuckin CRAZY",
    #"You're gonna summon the SHIT outta this spooky town tonight!!!",
    #"glhf",
]

func _ready() -> void:
    Input.set_use_accumulated_input(false)
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

    await title.dismissed

    await dialogue.show_dialogue(test_dialogue)

func _unhandled_input(event):
    $WorldViewport.push_input(event)
