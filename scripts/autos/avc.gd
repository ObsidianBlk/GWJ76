extends Node


# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal bus_volume_changed(bus : StringName, volume : float)

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const AUDIO_BUS_MASTER : StringName = &"Master"
const AUDIO_BUS_MUSIC : StringName = &"Music"
const AUDIO_BUS_SFX : StringName = &"SFX"

const SETTINGS_SECTION_AUDIO : String = "AUDIO"

const VOLUME_SCALE : float = 100.0
const VOLUME_MULTIPLIER : float = 1.0/VOLUME_SCALE

const DEFAULT_BUS_VOLUME : float = 100.0
const DEFAULT_BUS_VOLUME_MASTER : float = 100.0
const DEFAULT_BUS_VOLUME_MUSIC : float = 50.0
const DEFAULT_BUS_VOLUME_SFX : float = 80.0


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
#var _abus : Dictionary = {
	#AUDIO_BUS_MASTER: DEFAULT_BUS_VOLUME_MASTER,
	#AUDIO_BUS_MUSIC: DEFAULT_BUS_VOLUME_MUSIC,
	#AUDIO_BUS_SFX: DEFAULT_BUS_VOLUME_SFX
#}

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	Settings.reset.connect(_on_settings_reset)
	Settings.loaded.connect(_on_settings_loaded)
	Settings.value_changed.connect(_on_settings_value_changed)
	_UpdateAudioFromSettings()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateAudioFromSettings() -> void:
	var volume : float = Settings.get_value(SETTINGS_SECTION_AUDIO, AUDIO_BUS_MASTER, DEFAULT_BUS_VOLUME_MASTER)
	_SetBusVolume(AUDIO_BUS_MASTER, volume)
	bus_volume_changed.emit(AUDIO_BUS_MASTER, volume)
	
	volume = Settings.get_value(SETTINGS_SECTION_AUDIO, AUDIO_BUS_MUSIC, DEFAULT_BUS_VOLUME_MUSIC)
	_SetBusVolume(AUDIO_BUS_MUSIC, volume)
	bus_volume_changed.emit(AUDIO_BUS_MUSIC, volume)
	
	volume = Settings.get_value(SETTINGS_SECTION_AUDIO, AUDIO_BUS_SFX, DEFAULT_BUS_VOLUME_SFX)
	_SetBusVolume(AUDIO_BUS_SFX, volume)
	bus_volume_changed.emit(AUDIO_BUS_SFX, volume)


func _SetBusVolume(bus : StringName, volume : float) -> void:
	volume = clampf(volume, 0.0, VOLUME_SCALE) * VOLUME_MULTIPLIER
	
	var bus_idx : int = AudioServer.get_bus_index(bus)
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume))

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func set_bus_volume(bus : StringName, volume : float) -> void:
	volume = clampf(volume, 0.0, VOLUME_SCALE)
	Settings.set_value(SETTINGS_SECTION_AUDIO, bus, volume)

func reset_bus_volume(bus : StringName) -> void:
	if AudioServer.get_bus_index(bus) < 0: return
	match bus:
		AUDIO_BUS_MASTER:
			set_bus_volume(AUDIO_BUS_MASTER, DEFAULT_BUS_VOLUME_MASTER)
		AUDIO_BUS_MUSIC:
			set_bus_volume(AUDIO_BUS_MUSIC, DEFAULT_BUS_VOLUME_MUSIC)
		AUDIO_BUS_SFX:
			set_bus_volume(AUDIO_BUS_SFX, DEFAULT_BUS_VOLUME_SFX)
		_:
			set_bus_volume(bus, DEFAULT_BUS_VOLUME)

func get_bus_volume(bus : StringName) -> float:
	var volume : float = 0.0
	var bus_idx : int = AudioServer.get_bus_index(bus)
	if bus_idx >= 0:
		volume = db_to_linear(AudioServer.get_bus_volume_db(bus_idx))
	return volume * VOLUME_SCALE

func has_bus(bus : StringName) -> bool:
	return AudioServer.get_bus_index(bus) >= 0

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_settings_reset() -> void:
	set_bus_volume(AUDIO_BUS_MASTER, DEFAULT_BUS_VOLUME_MASTER)
	set_bus_volume(AUDIO_BUS_MUSIC, DEFAULT_BUS_VOLUME_MUSIC)
	set_bus_volume(AUDIO_BUS_SFX, DEFAULT_BUS_VOLUME_SFX)

func _on_settings_loaded() -> void:
	_UpdateAudioFromSettings()

func _on_settings_value_changed(section : String, key : String, value : Variant) -> void:
	if section == SETTINGS_SECTION_AUDIO:
		if typeof(value) != TYPE_FLOAT: return
		if has_bus(key):
			_SetBusVolume(key, value)
			bus_volume_changed.emit(key, value)
