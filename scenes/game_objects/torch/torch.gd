extends Node3D

@export var starts_lit := false

@onready var interactable: Interactable = $Interactable
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var fire_particles: GPUParticles3D = $FireParticles

var lit := false


func _ready() -> void:
    interactable.was_interacted_with.connect(on_interact)
    if starts_lit:
        light_torch()


func light_torch() -> void:
    interactable.prompt_map.erase("Lamp")
    omni_light_3d.visible = true
    fire_particles.emitting = true
    lit = true


func on_interact(item: Interactable) -> void:
    if not lit and item.item_name == "Lamp":
        light_torch()
