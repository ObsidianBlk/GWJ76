extends ElfState
class_name ElfStatePickup


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_WORK : StringName = &"work"
const TRANSITION_IDLE : StringName = &"Idle"

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _interactable : Interactable = null


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter(payload : Variant = null) -> void:
	if host == null: return
	if interact_component == null: return
	_interactable = interact_component.get_interactable()
	if _interactable != null:
		host.animation_looped.connect(_on_host_animation_looped)
		#host.animation_finished.connect(_on_host_animation_finished)
		play_animation(ANIM_WORK)
	else:
		transition.emit(TRANSITION_IDLE)

func exit() -> void:
	host.animation_looped.disconnect(_on_host_animation_looped)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_host_animation_looped(anim_name : StringName) -> void:
	if anim_name.begins_with(ANIM_WORK):
		if _interactable != null:
			_interactable.interact()
		transition.emit(TRANSITION_IDLE)
