extends ColorRect


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const MIN_SPEED : float = 0.5
const MAX_SPEED : float = 7.5

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _last_speed : float = 0.0

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func set_intensity(intensity : float) -> void:
	intensity = clampf(1.0 - intensity, 0.0, 1.0)
	if intensity > 0.9:
		intensity = 1.0
	elif intensity >= 0.7:
		intensity = 0.75
	elif intensity >= 0.5:
		intensity = 0.5
	elif intensity >= 0.3:
		intensity = 0.3
	elif intensity < 0.3:
		intensity = 0.0
	if material is ShaderMaterial:
		var delta : float = MAX_SPEED - MIN_SPEED
		var speed : float = floor(MIN_SPEED + (delta * intensity))
		if not is_equal_approx(speed, _last_speed):
			_last_speed = speed
			material.set_shader_parameter(&"speed", speed)
