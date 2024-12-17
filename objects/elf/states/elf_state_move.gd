extends ElfState
class_name ElfStateMove

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_WALK = &"walk"

const TRANSITION_IDLE : StringName = &"Idle"
const TRANSITION_CHOP : StringName = &"Chop"

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
func _HandleInteraction() -> void:
	if interact_component == null: return
	var interactable : Interactable = interact_component.get_interactable()
	if interactable == null: return
	
	match interactable.type:
		Interactable.IType.TRUNK:
			host.velocity = Vector2.ZERO
			transition.emit(TRANSITION_CHOP)
		Interactable.IType.MISC:
			interactable.interact()

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
		transition.emit(TRANSITION_IDLE)
	else:
		play_animation(ANIM_WALK)

func handle_input(event : InputEvent) -> void:
	if event.is_action_pressed(&"game.interact"):
		if interact_component != null:
			var interactable : Interactable = interact_component.get_interactable()
			if interactable != null:
				interactable.interact()
	if is_event_action(event, [&"game.move_left", &"game.move_right"]):
		_idirection.x = Input.get_axis(&"game.move_left", &"game.move_right")
	if is_event_action(event, [&"game.move_up", &"game.move_down"]):
		_idirection.y = Input.get_axis(&"game.move_up", &"game.move_down")

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



