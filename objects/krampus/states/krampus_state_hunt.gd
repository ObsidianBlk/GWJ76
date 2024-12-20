extends KrampusState
class_name KrampusStateHunt


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_WALK : StringName = &"walk"

const TRANSITION_IDLE : StringName = &"Idle"
const TRANSITION_RETREAT : StringName = &"Retreat"
const TRANSITION_BREAK : StringName = &"Break"

const WEATHER_INTENSITY_HUNT : float = 0.15

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var max_speed : float = 70.0
@export var acceleration : float = 0.1
@export var deceleration : float = 0.25

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _target : Node2D = null


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateTarget() -> bool:
	if host.is_elf_hunt_allowed():
		if not _target is Elf:
			var target : Elf = host.find_elf()
			_target = target
			if target == null or target.is_dead():
				_target = null
			else:
				host.set_target(_target)
	elif not _target is WindowBreak:
		_target = host.find_window()
		host.set_target(_target)
	return _target != null

func _UpdateWeatherIntensity() -> bool:
	var weather_intensity : float = host.get_weather_intensity()
	if weather_intensity > WEATHER_INTENSITY_HUNT:
		return false
	return true

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter(payload : Variant = null) -> void:
	if host == null: return
	print("Krampus Hunt")
	play_animation(ANIM_WALK)

func exit() -> void:
	_target = null

func update(_delta : float) -> void:
	if not _UpdateWeatherIntensity():
		transition.emit(TRANSITION_RETREAT)
		return
	if not _UpdateTarget():
		transition.emit(TRANSITION_IDLE)
		return
	host.update_agent_target()

	var agent : NavigationAgent2D = host.get_agent()
	if agent.is_navigation_finished():
		if agent.is_target_reachable():
			transition.emit(TRANSITION_BREAK)
		else:
			_target = null
	else:
		var pos : Vector2 = agent.get_next_path_position()
		var dir : Vector2 = host.global_position.direction_to(pos)
		host.update_velocity(dir, max_speed, acceleration, deceleration)
		host.move_and_slide()
