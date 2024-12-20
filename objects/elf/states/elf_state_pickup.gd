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
var _free_carrying : bool = false


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func enter(payload : Variant = null) -> void:
	if host == null: return
	_interactable = get_priority_interactable()
	if _interactable != null:
		if typeof(payload) == TYPE_BOOL:
			_free_carrying = payload
		host.animation_looped.connect(_on_host_animation_looped)
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
		if _free_carrying:
			host.free_carrying(true)
		if _interactable != null:
			_interactable.interact()
		transition.emit(TRANSITION_IDLE)
