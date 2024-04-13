extends RayCast3D

signal interactable_changed(interactable: Interactable)

var interactable: Interactable = null

func _physics_process(delta: float) -> void:
    var new_interactable = get_collider() as Interactable
    if new_interactable == interactable:
        return

    interactable_changed.emit(new_interactable)

    interactable = new_interactable


func _ready() -> void:
    pass
