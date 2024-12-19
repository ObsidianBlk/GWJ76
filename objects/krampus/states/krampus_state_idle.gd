extends KrampusState
class_name KrampusStateIdle


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_IDLE : StringName = &"idle"

const TRANSITION_HUNT : StringName = &"Hunt"

const WEATHER_INTENSITY_HUNT : float = 0.15

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter(payload : Variant = null) -> void:
	if host == null: return
	play_animation(ANIM_IDLE)

func update(_delta : float) -> void:
	var weather_intensity : float = host.get_weather_intensity()
	if weather_intensity <= WEATHER_INTENSITY_HUNT:
		transition.emit(TRANSITION_HUNT)
