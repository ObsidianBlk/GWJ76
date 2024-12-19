extends Area2D
class_name HeaterComponent

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal temperature(amount : float)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_range(0.0, 1.0) var intensity : float = 0.5 : 	set=set_intensity
@export var heat_value : float = 20.0
@export var variance : float = 0.2

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_intensity(i : float) -> void:
	if i >= 0.0 and i <= 1.0:
		intensity = i

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	_GetTemperature()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _GetTemperature() -> void:
	var base_heat = lerpf(0.0, heat_value, intensity)
	var base_variance : float = variance * (1.0 - intensity)
	var heat_variance : float = randf_range(-base_variance, base_variance)
	var adj : float = base_heat * heat_variance
	temperature.emit(heat_value + adj)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_area_entered(area : Area2D) -> void:
	if area is TemperatureComponent:
		if not temperature.is_connected(area.add_temperature):
			temperature.connect(area.add_temperature)

func _on_area_exited(area : Area2D) -> void:
	if area is TemperatureComponent:
		if temperature.is_connected(area.add_temperature):
			temperature.disconnect(area.add_temperature)
