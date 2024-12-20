extends ElfState
class_name ElfStatePutdown


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
	
	_interactable = host.get_priority_interactable()
	if host.is_carrying() and _interactable != null and _interactable.placeable:
		if not host.animation_looped.is_connected(_on_host_animation_looped):
			host.animation_looped.connect(_on_host_animation_looped)
		play_animation(ANIM_WORK)
	else:
		transition.emit(TRANSITION_IDLE)

func exit() -> void:
	if host.animation_looped.is_connected(_on_host_animation_looped):
		host.animation_looped.disconnect(_on_host_animation_looped)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_host_animation_looped(anim_name : StringName) -> void:
	if anim_name.begins_with(ANIM_WORK):
		if _interactable != null:
			var item : Node2D = host.get_carrying()
			host.free_carrying()
			_interactable.place(item)
		transition.emit(TRANSITION_IDLE)
