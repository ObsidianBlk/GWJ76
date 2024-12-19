extends Node2D


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const RADIUS : float = 128.0

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var hide_modulation : Color = Color.TRANSPARENT

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _krampus : Krampus = null

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	if _krampus == null:
		set_process(false)

func _process(_delta: float) -> void:
	if _krampus == null: return
	var dist : float = global_position.distance_to(_krampus.global_position)
	_krampus.modulate = lerp(hide_modulation, Color.WHITE, dist / RADIUS)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_body_entered(body: Node2D) -> void:
	if _krampus != null or not body is Krampus: return
	_krampus = body
	set_process(true)

func _on_body_exited(body: Node2D) -> void:
	if _krampus == body:
		_krampus.modulate = Color.WHITE
		_krampus = null
		set_process(false)
