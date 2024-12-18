extends CharacterBody2D
class_name Elf

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal dead(reason : StringName)
signal animation_finished(anim_name : StringName)
signal animation_looped(anim_name : StringName)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const TRANSITION_DEATH : StringName = &"Death"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _carrying : Node2D = null
var _pulsing_body_temp : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _carry_container: Node2D = %CarryContainer
@onready var _sprite: AnimatedSprite2D = $ASprite
@onready var _temperature_bar: TextureProgressBar = %TemperatureBar

@onready var _state_machine: StateMachine = %StateMachine


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_temperature_bar.modulate = Color.TRANSPARENT
	_sprite.animation_finished.connect(_on_sprite_animation_finished)
	_sprite.animation_looped.connect(_on_sprite_animation_looped)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _PulseBodyTempBar(fade_in : float, fade_out : float, hold : float, count : int = 1) -> void:
	if _pulsing_body_temp or fade_in <= 0.0 or fade_out < 0.0: return
	_pulsing_body_temp = true
	
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(false)
	for i : int in range(count):
		tween.tween_property(_temperature_bar, "modulate", Color.WHITE, fade_in)
		tween.tween_interval(hold)
		tween.tween_property(_temperature_bar, "modulate", Color.TRANSPARENT, fade_out)
	await tween.finished
	_pulsing_body_temp = false

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

func update_velocity(direction : Vector2, speed : float, acceleration : float, deceleration : float) -> void:
	if direction.is_equal_approx(Vector2.ZERO):
		velocity.x = lerpf(velocity.x, 0.0, deceleration)
		velocity.y = lerpf(velocity.y, 0.0, deceleration)
	else:
		direction = direction.normalized()
		velocity.x = lerpf(velocity.x, direction.x * speed, acceleration)
		velocity.y = lerpf(velocity.y, direction.y * speed, acceleration)

func show_body_temp() -> void:
	if _pulsing_body_temp: return
	_PulseBodyTempBar(0.2, 0.1, 1.0)

func is_carrying() -> bool:
	return _carrying != null

func throw_carrying() -> void:
	if _carrying == null: return
	var parent : Node = get_parent()
	if parent == null: return
	
	_carry_container.remove_child(_carrying)
	parent.add_child(_carrying)
	_carrying.position = _carry_container.global_position
	_carrying = null
	
	# TODO: Add the ThrowComponent to send the item flying

func free_carrying() -> void:
	if _carrying == null: return
	_carry_container.remove_child(_carrying)
	_carrying.queue_free()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_pickup_requested(pickup : Node2D) -> void:
	if _carrying != null or pickup == null: return
	var parent : Node = pickup.get_parent()
	if parent != null:
		parent.remove_child(pickup)
	_carry_container.add_child(pickup)
	pickup.position = Vector2.ZERO
	_carrying = pickup

func _on_sprite_animation_finished() -> void:
	if _sprite == null: return
	animation_finished.emit(_sprite.animation)

func _on_sprite_animation_looped() -> void:
	if _sprite == null: return
	animation_looped.emit(_sprite.animation)

func _on_body_temp_changed(body_temp: float) -> void:
	_temperature_bar.value = body_temp
	if body_temp < 250:
		if not _pulsing_body_temp:
			_PulseBodyTempBar(0.1, 0.1, 0.2)
		if body_temp <= 0.0:
			_state_machine.transition_state(TRANSITION_DEATH, GameWorld.DEATH_REASON_FROZEN)
