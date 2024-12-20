extends Control


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
enum AudioBus {MASTER=0, MUSIC=1, SFX=2}
const ABLUT : Array[StringName] = [&"Master", &"Music", &"SFX"]


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var audio_bus : AudioBus = AudioBus.MASTER

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _slider_value: HSlider = %Slider_Value
@onready var _progress: ProgressBar = %Progress

# ------------------------------------------------------------------------------
# Setters
# ------------------------------------------------------------------------------
func set_audio_bus(ab : AudioBus) -> void:
	if audio_bus != ab:
		audio_bus = ab
		_UpdateVolume()


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	AVC.bus_volume_changed.connect(_on_bus_volume_changed)
	_UpdateVolume()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateVolume() -> void:
	var volume : float = AVC.get_bus_volume(ABLUT[audio_bus])
	_slider_value.set_value_no_signal(volume)
	_progress.set_value_no_signal(volume)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_bus_volume_changed(bus : StringName, volume : float) -> void:
	if bus == ABLUT[audio_bus]:
		_slider_value.set_value_no_signal(volume)
		_progress.set_value_no_signal(volume)

func _on_slider_value_changed(value: float) -> void:
	AVC.set_bus_volume(ABLUT[audio_bus], value)
