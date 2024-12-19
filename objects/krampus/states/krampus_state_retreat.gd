extends KrampusState
class_name KrampusStateRetreat

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_WALK : StringName = &"walk"
const TRANSITION_IDLE : StringName = &"Idle"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var max_speed : float = 85.0
@export var acceleration : float = 0.1
@export var deceleration : float = 0.25


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter(payload : Variant = null) -> void:
	if host == null: return
	var target : Node2D = host.find_hide_point()
	host.set_target(target)
	play_animation(ANIM_WALK)
	host.velocity = Vector2.ZERO


func update(_delta : float) -> void:
	var agent : NavigationAgent2D = host.get_agent()
	if agent.is_navigation_finished():
		transition.emit(TRANSITION_IDLE)
	else:
		var pos : Vector2 = agent.get_next_path_position()
		var dir : Vector2 = host.global_position.direction_to(pos).normalized()
		host.update_velocity(dir, max_speed, acceleration, deceleration)
		host.move_and_slide()
