extends Node3D

@export var starts_lit := false

@onready var interactable: Interactable = $Interactable
@onready var omni_light_3d: OmniLight3D = $OmniLight3D
@onready var fire_particles: GPUParticles3D = $FireParticles
@onready var light_torch_audio_player: AudioStreamPlayer3D = $LightTorchAudioPlayer
@onready var ambient_audio_player: AudioStreamPlayer3D = $AmbientAudioPlayer

var lit := false


func _ready() -> void:
    interactable.was_interacted_with.connect(on_interact)
    interactable.was_pondered_while_holding.connect(on_ponder)

    if starts_lit:
        light_torch()


func light_torch() -> void:
    omni_light_3d.visible = true
    fire_particles.emitting = true
    light_torch_audio_player.play()
    ambient_audio_player.play()
    lit = true


func on_ponder(held_item: Holdable) -> void:
    if not lit and held_item != null and held_item.owner.name == "Pyron":
        GameEvents.emit_update_prompt("Light Torch using %s" % [held_item.owner.name])
        return

    GameEvents.emit_update_prompt("")


func on_interact(held_item: Holdable) -> void:
    if not lit and held_item.owner.name == "Pyron":
        light_torch()
