extends Node
class_name StateMachine


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var initial_state : StringName = &""

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _states : Dictionary = {}
var _current : State = null

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	await owner.ready
	for child : Node in get_children():
		if child is State:
			_ConnectChildState(child)
			_states[child.name] = child
	_on_child_transition(initial_state)

func _unhandled_input(event: InputEvent) -> void:
	if _current == null: return
	_current.handle_input(event)

func _process(delta: float) -> void:
	if _current == null: return
	_current.update(delta)

func _physics_process(delta: float) -> void:
	if _current == null: return
	_current.physics_update(delta)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ConnectChildState(child : State) -> void:
	if child == null: return
	if not child.transition.is_connected(_on_child_transition):
		child.transition.connect(_on_child_transition)

func _DisconnectChildState(child : State) -> void:
	if child == null: return
	if child.transition.is_connected(_on_child_transition):
		child.transition.disconnect(_on_child_transition)


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_child_transition(state_name : StringName) -> void:
	if state_name in _states:
		if _states[state_name] == _current: return
		if _current != null:
			_current.exit()
			_current = null
		_current = _states[state_name]
		_current.enter()
