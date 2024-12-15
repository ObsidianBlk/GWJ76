extends ElfState
class_name ElfStateMove

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_WALK = &"walk"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var max_speed : float = 80.0
@export var acceleration : float = 0.1
@export var deceleration : float = 0.25

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _idirection : Vector2 = Vector2.ZERO

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter() -> void:
	if host == null: return
	_idirection.x = Input.get_axis(&"game.move_left", &"game.move_right")
	_idirection.y = Input.get_axis(&"game.move_up", &"game.move_down")

func exit() -> void:
	pass

func update(_delta : float) -> void:
	pass

func physics_update(_delta : float) -> void:
	if host == null: return
	host.update_velocity(_idirection, max_speed, acceleration, deceleration)
	host.move_and_slide()
	set_facing_from_velocity()
	if host.velocity.length_squared() < 1.0:
		host.velocity = Vector2.ZERO
		transition.emit(&"Idle")
	else:
		play_animation(ANIM_WALK)

func handle_input(event : InputEvent) -> void:
	if is_event_action(event, [&"game.move_left", &"game.move_right"]):
		_idirection.x = Input.get_axis(&"game.move_left", &"game.move_right")
	if is_event_action(event, [&"game.move_up", &"game.move_down"]):
		_idirection.y = Input.get_axis(&"game.move_up", &"game.move_down")

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



