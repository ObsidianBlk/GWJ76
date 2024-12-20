extends KrampusState
class_name KrampusStateIdle


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_IDLE : StringName = &"idle"

const TRANSITION_HUNT : StringName = &"Hunt"


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_range(0.0, 1.0) var max_hunt_weather_intensity : float = 0.02

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _already_hunted : bool = true

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter(payload : Variant = null) -> void:
	if host == null: return
	print("Krampus Idle")
	play_animation(ANIM_IDLE)

func update(_delta : float) -> void:
	var weather_intensity : float = host.get_weather_intensity()
	if weather_intensity <= max_hunt_weather_intensity:
		if not _already_hunted:
			_already_hunted = true
			transition.emit(TRANSITION_HUNT)
	elif _already_hunted:
		_already_hunted = false
