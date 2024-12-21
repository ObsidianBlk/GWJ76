extends CharacterBody2D
class_name Santa

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal destination_reached()
signal elf_interacted()

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _tweening : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _interactable: Interactable = %Interactable
@onready var _collision: CollisionShape2D = %CollisionShape2D


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
@onready var _viz: SantaViz = $Viz


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _TweenToDestination(viz_state : SantaViz.Viz, destination : Vector2, duration: float) -> void:
	if _tweening: return
	_tweening = true
	_viz.state = viz_state
	
	if duration > 0.0:
		var tween : Tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "global_position", destination, duration)
		await tween.finished
	else:
		global_position = destination
	_tweening = false
	_viz.state = SantaViz.Viz.IDLE
	destination_reached.emit()

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func interactable(enable : bool) -> void:
	_interactable.interactable = enable
	_collision.disabled = not enable

func fly_to(destination : Vector2, duration : float) -> void:
	_TweenToDestination(SantaViz.Viz.FLIGHT, destination, duration)

func walk_to(destination : Vector2, duration : float) -> void:
	_TweenToDestination(SantaViz.Viz.WALK, destination, duration)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_interactable_interacted() -> void:
	elf_interacted.emit()
