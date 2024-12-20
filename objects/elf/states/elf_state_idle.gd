extends ElfState
class_name ElfStateIdle

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_IDLE : StringName = &"idle"
const ANIM_BLINK : StringName = &"blink"

const TRANSITION_MOVE : StringName = &"Move"
const TRANSITION_CHOP : StringName = &"Chop"
const TRANSITION_PICKUP : StringName = &"Pickup"
const TRANSITION_PUTDOWN : StringName = &"Putdown"

const ACTION_NO_BLINK : StringName = &"no_blink"
const ACTION_BLINK : StringName = &"blink"

const BLINK_CHECK_DELAY : float = 0.25

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _blink_weight : WeightedRandomCollection = WeightedRandomCollection.new([
	{&"ID":ACTION_NO_BLINK, &"Weight":80.0},
	{&"ID":ACTION_BLINK, &"Weight":20.0}
])
var _blink_check : float = BLINK_CHECK_DELAY

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _HandleInteraction() -> void:
	if interact_component == null: return
	var interactable : Interactable = get_priority_interactable()
	if interactable != null:
		match interactable.type:
			Interactable.IType.TRUNK:
				if not host.is_carrying():
					transition.emit(TRANSITION_CHOP)
			Interactable.IType.PICKUP:
				if not host.is_carrying() and interactable.interactable:
					transition.emit(TRANSITION_PICKUP)
			Interactable.IType.FIRE:
				if host.get_carrying() is Log:
					host.free_carrying(true)
					interactable.interact()
			Interactable.IType.WOOD_STATION:
				if host.get_carrying() is Log:
					transition.emit(TRANSITION_PUTDOWN)
				elif interactable.interactable:
					transition.emit(TRANSITION_CHOP)
			Interactable.IType.WINDOW:
				if host.get_carrying() is Planks and interactable.interactable:
					transition.emit(TRANSITION_PICKUP, true)
			Interactable.IType.MISC:
				interactable.interact()
	elif host.is_carrying():
		host.throw_carrying(facing_name())

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter(payload : Variant = null) -> void:
	if host == null: return
	host.animation_finished.connect(_on_host_animation_finished)
	play_animation(ANIM_IDLE)

func exit() -> void:
	host.animation_finished.disconnect(_on_host_animation_finished)

func update(delta : float) -> void:
	if _blink_check > 0.0:
		_blink_check -= delta
	else:
		if is_playing(ANIM_IDLE) and _blink_weight.get_random() == ACTION_BLINK:
			play_animation(ANIM_BLINK)
		_blink_check = BLINK_CHECK_DELAY

func handle_input(event : InputEvent) -> void:
	if event.is_action_pressed(&"game.interact"):
		_HandleInteraction()
	if event.is_action_pressed(&"game.show_body_temp"):
		host.show_body_temp()
	if is_event_action(event, [&"game.move_up", &"game.move_down", &"game.move_left", &"game.move_right"]):
		transition.emit(TRANSITION_MOVE)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_host_animation_finished(anim_name : StringName) -> void:
	if anim_name.begins_with(ANIM_BLINK):
		play_animation(ANIM_IDLE)
