extends CharacterBody2D
class_name Elf

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal animation_finished(anim_name : StringName)
signal animation_looped(anim_name : StringName)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _carrying : Node2D = null

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _sprite: AnimatedSprite2D = $ASprite


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_sprite.animation_finished.connect(_on_sprite_animation_finished)
	_sprite.animation_looped.connect(_on_sprite_animation_looped)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


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

func is_carrying() -> bool:
	return _carrying != null

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_sprite_animation_finished() -> void:
	if _sprite == null: return
	animation_finished.emit(_sprite.animation)

func _on_sprite_animation_looped() -> void:
	if _sprite == null: return
	animation_looped.emit(_sprite.animation)
