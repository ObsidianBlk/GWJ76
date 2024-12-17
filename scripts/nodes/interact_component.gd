extends Area2D
class_name InteractComponent

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal interact_entered(interactable : Interactable)
signal interact_exited(interactable : Interactable)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _interactable : WeakRef = weakref(null)

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func get_interactable() -> Interactable:
	return _interactable.get_ref()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_area_entered(area : Area2D) -> void:
	var interactable : Interactable = _interactable.get_ref()
	if area is Interactable and interactable == null:
		_interactable = weakref(area)
		interact_entered.emit(area)

func _on_area_exited(area : Area2D) -> void:
	var interactable : Interactable = _interactable.get_ref()
	if area is Interactable and interactable == area:
		_interactable = weakref(null)
		interact_exited.emit(area)


