extends CharacterBody2D
class_name Krampus


const GROUP_KRAMPUS_HIDE : StringName = &"KrampusHide"
const GROUP_WINDOW_BREAK : StringName = &"WindowBreak"
const GROUP_ELF : StringName = &"Elf"

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _target : Node2D = null
var _last_target_pos : Vector2 = Vector2.ZERO
var _allow_elf_hunt : bool = false
var _weather_intensity : float = 0.0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var _agent: NavigationAgent2D = %NavigationAgent2D


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func flip(enable : bool) -> void:
	if _sprite == null: return
	_sprite.flip_h = enable

func play_animation(anim_name : StringName) -> void:
	if _sprite == null: return
	if _sprite.sprite_frames.has_animation(anim_name) and _sprite.animation != anim_name:
		_sprite.play(anim_name)

func get_animation() -> StringName:
	if _sprite == null: return &""
	return _sprite.animation

func get_agent() -> NavigationAgent2D:
	return _agent

func set_weather_intensity(i : float) -> void:
	_weather_intensity = clampf(i, 0.0, 1.0)

func get_weather_intensity() -> float:
	return _weather_intensity

func set_allow_elf_hunt(allow : bool) -> void:
	_allow_elf_hunt = allow

func is_elf_hunt_allowed() -> bool:
	return _allow_elf_hunt

func set_target(target : Node2D) -> void:
	if target == _target: return
	_target = target
	if _target != null:
		_last_target_pos = _target.global_position
		_agent.target_position = _target.global_position

func get_target() -> Node2D:
	return _target

func update_agent_target(force_target_update : bool = false) -> void:
	if _target == null: return
	if not force_target_update and _target.global_position.is_equal_approx(_last_target_pos): return
	_agent.target_position = _target.global_position

func update_velocity(direction : Vector2, speed : float, acceleration : float, deceleration : float) -> void:
	if direction.is_equal_approx(Vector2.ZERO):
		velocity.x = lerpf(velocity.x, 0.0, deceleration)
		velocity.y = lerpf(velocity.y, 0.0, deceleration)

	else:
		direction = direction.normalized()
		velocity.x = lerpf(velocity.x, direction.x * speed, acceleration)
		velocity.y = lerpf(velocity.y, direction.y * speed, acceleration)

func find_hide_point() -> Node2D:
	var hidepoints : Array[Node] = get_tree().get_nodes_in_group(GROUP_KRAMPUS_HIDE)
	hidepoints = hidepoints.filter(func(item : Node): return item is Node2D)
	if hidepoints.size() > 0:
		var idx : int = randi_range(0, hidepoints.size() - 1)
		return hidepoints[idx]
	return null

func find_window() -> WindowBreak:
	var winds : Array[Node] = get_tree().get_nodes_in_group(GROUP_WINDOW_BREAK)
	winds = winds.filter(func(item : Node): return item is WindowBreak)
	if winds.size() > 0:
		var idx : int = randi_range(0, winds.size() - 1)
		return winds[idx]
	return null

func find_elf() -> Elf:
	var elves : Array[Node] = get_tree().get_nodes_in_group(GROUP_ELF)
	elves = elves.filter(func(item : Node): return item is Elf)
	if elves.size() > 0:
		return elves[0]
	return null
