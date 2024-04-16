extends Control

@onready var prompt_label: Label = $Prompt

func _ready() -> void:
    GameEvents.update_prompt.connect(update_prompt)
    prompt_label.text = ""


func update_prompt(prompt: String) -> void:
    if prompt == null or prompt == "":
        prompt_label.text = ""
        return
    prompt_label.text = "E: " + prompt
