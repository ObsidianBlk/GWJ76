extends Node
class_name ThrowComponent

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal throw_completed()

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
enum Direction {UP=0, DOWN=1, LEFT=2, RIGHT=3}

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var duration : float = 1.0
@export var height : float = 24.0
@export var distance : float = 64.0
@export var direction : Direction = Direction.DOWN
@export var drop_curve : Curve = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _original_position : Vector2 = Vector2.ZERO
var _original_z : int = 0
var _dur : float = 0.0
var _progress : float = 0.0
var _target : Node2D = null


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	_dur = min(duration, _dur + delta)
	_progress = _dur / duration
	_target.position.y = _original_position.y + _GetCurveValue() * height
	_UpdateZOrder()
	if is_equal_approx(_dur, duration):
		set_process(false)
		throw_completed.emit()
		queue_free()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _GetCurveValue() -> float:
	if drop_curve != null:
		return drop_curve.sample(_progress)
	return _progress

func _UpdateZOrder() -> void:
	if direction == Direction.DOWN and _progress > 0.8:
		_target.z_index = _original_z

func _StartLRTween() -> void:
	if _target == null: return
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	match direction:
		Direction.LEFT:
			tween.tween_property(_target, "position:x", _target.position.x - distance, duration)
		Direction.RIGHT:
			tween.tween_property(_target, "position:x", _target.position.x + distance, duration)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func start() -> int:
	var parent : Node = get_parent()
	if not parent is Node2D:
		return ERR_UNAVAILABLE
	_target = parent
	_original_position = parent.position
	match direction:
		Direction.LEFT, Direction.RIGHT:
			_StartLRTween()
		Direction.DOWN:
			_original_z = _target.z_index
			_target.z_index = _original_z + 1
	set_process(true)
	return OK
