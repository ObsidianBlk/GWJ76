extends Node2D
class_name WindowBreak

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var window : Node2D = null


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func break_window() -> void:
	if window == null: return
	if window.has_method(&"set_broken"):
		window.set_broken(true)
