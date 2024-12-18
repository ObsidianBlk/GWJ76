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


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	temperature.emit(_GetTemperature())

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _GetTemperature() -> float:
	var heat_variance : float = randf_range(-variance, variance)
	var adj : float = heat_value * heat_variance
	return heat_value + adj

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


