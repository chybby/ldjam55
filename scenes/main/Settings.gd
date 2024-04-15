extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var return_button: Button = %ReturnButton
@onready var quit_button: Button = %QuitButton

var enabled := false

func _ready() -> void:
    return_button.pressed.connect(on_return_button_pressed)
    quit_button.pressed.connect(on_quit_button_pressed)
    master_slider.value_changed.connect(on_master_slider_value_changed)
    music_slider.value_changed.connect(on_music_slider_value_changed)
    sfx_slider.value_changed.connect(on_sfx_slider_value_changed)
    get_tree().get_first_node_in_group("title").dismissed.connect(on_title_dismissed)


func _input(event) -> void:
    if enabled and event.is_action_pressed("escape"):
        accept_event()
        toggle_settings()


func toggle_settings() -> void:
        
        if not get_tree().paused:
            animation_player.play("background_blur")
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            animation_player.play_backwards("background_blur")
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED        
            await animation_player.animation_finished

        visible = not visible
        get_tree().paused = not get_tree().paused

func on_return_button_pressed() -> void:
    toggle_settings()
    
    
func on_quit_button_pressed() -> void:
    get_tree().quit()

func change_audio_bus_volume(bus_idx: int, value: float) -> void:
    AudioServer.set_bus_volume_db(bus_idx, value)


func on_master_slider_value_changed(value: float) -> void:
    var master_bus_idx := AudioServer.get_bus_index("Master")
    change_audio_bus_volume(master_bus_idx, value)


func on_music_slider_value_changed(value: float) -> void:
    var music_bus_idx := AudioServer.get_bus_index("Music")
    change_audio_bus_volume(music_bus_idx, value)        


func on_sfx_slider_value_changed(value: float) -> void:
    var sfx_bus_idx := AudioServer.get_bus_index("SFX_dry")
    change_audio_bus_volume(sfx_bus_idx, value)
    
func on_title_dismissed() -> void:
    enabled = true
