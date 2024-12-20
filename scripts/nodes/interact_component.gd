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
var _interactables : Array[WeakRef] = []

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
func _GetIndex(item : Interactable) -> int:
	for idx : int in range(_interactables.size()):
		if _interactables[idx].get_ref() == item:
			return idx
	return -1

func _CleanList() -> void:
	_interactables = _interactables.filter(func(item : WeakRef): return item.get_ref() != null)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func get_count() -> int:
	_CleanList()
	return _interactables.size()

func get_interactable(idx : int = 0) -> Interactable:
	_CleanList()
	if idx >= 0 and idx < _interactables.size():
		return _interactables[idx].get_ref()
	return null

func get_interactables() -> Array[Interactable]:
	_CleanList()
	var arr : Array[Interactable] = []
	for act : WeakRef in _interactables:
		arr.append(act.get_ref())
	return arr

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_area_entered(area : Area2D) -> void:
	if area is Interactable and _GetIndex(area) < 0:
		_interactables.append(weakref(area))
		interact_entered.emit(area)

func _on_area_exited(area : Area2D) -> void:
	if area is Interactable:
		var idx : int = _GetIndex(area)
		if idx >= 0:
			_interactables.remove_at(idx)
		interact_exited.emit(area)
