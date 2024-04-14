extends Control

@onready var prompt_label: Label = $Prompt

func _ready() -> void:
    GameEvents.update_prompt.connect(update_prompt)
    prompt_label.text = ""


func update_prompt(prompt: String) -> void:
    prompt_label.text = prompt
