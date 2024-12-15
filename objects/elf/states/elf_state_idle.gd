extends ElfState
class_name ElfStateIdle

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_IDLE : StringName = &"idle"
const ANIM_BLINK : StringName = &"blink"

const ACTION_NO_BLINK : StringName = &"no_blink"
const ACTION_BLINK : StringName = &"blink"

const BLINK_CHECK_DELAY : float = 0.25

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _blink_weight : WeightedRandomCollection = WeightedRandomCollection.new([
	{&"ID":ACTION_NO_BLINK, &"Weight":80.0},
	{&"ID":ACTION_BLINK, &"Weight":20.0}
])
var _blink_check : float = BLINK_CHECK_DELAY

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter() -> void:
	if host == null: return
	play_animation(&"idle")

func update(delta : float) -> void:
	if _blink_check > 0.0:
		_blink_check -= delta
	else:
		if is_playing(ANIM_IDLE) and _blink_weight.get_random() == ACTION_BLINK:
			play_animation(ANIM_BLINK)
		_blink_check = BLINK_CHECK_DELAY

func handle_input(event : InputEvent) -> void:
	if is_event_action(event, [&"game.move_up", &"game.move_down", &"game.move_left", &"game.move_right"]):
		transition.emit(&"Move")

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



