extends Node
class_name State


# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal transition(state_name : StringName)

# ------------------------------------------------------------------------------
# Virtual Methods
# ------------------------------------------------------------------------------
func enter(payload : Variant = null) -> void:
	pass

func exit() -> void:
	pass

func update(_delta : float) -> void:
	pass

func physics_update(_delta : float) -> void:
	pass

func handle_input(event : InputEvent) -> void:
	pass
