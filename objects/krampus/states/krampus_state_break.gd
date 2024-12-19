extends KrampusState
class_name KrampusStateBreak

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_IDLE : StringName = &"idle"
const TRANSITION_IDLE : StringName = &"Idle"
const TRANSITION_RETREAT : StringName = &"Retreat"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var wait_time : float = 1.0

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _target : Node2D = null
var _wait_time : float = 0.0

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter(payload : Variant = null) -> void:
	if host == null: return
	var target : Node2D = host.get_target()
	if target is WindowBreak or target is Elf:
		_target = target
		_wait_time = wait_time
		play_animation(ANIM_IDLE)
		host.velocity = Vector2.ZERO
	else:
		transition.emit(TRANSITION_IDLE)

func update(delta : float) -> void:
	if _wait_time > 0.0:
		_wait_time -= delta
	else:
		if _target is WindowBreak:
			_target.break_window()
		elif _target is Elf:
			pass
		transition.emit(TRANSITION_RETREAT)
