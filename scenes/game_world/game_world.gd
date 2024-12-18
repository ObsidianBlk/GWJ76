extends Node2D
class_name GameWorld

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal pickup_requested(item : Node2D)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const DEATH_REASON_CAPTURED : StringName = &"Captured"
const DEATH_REASON_FROZEN : StringName = &"Frozen"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_range(1, 10) var max_logs : int = 5

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _logs : Array[Log] = []


# ------------------------------------------------------------------------------
# Static Variables
# ------------------------------------------------------------------------------
static var _Instance : GameWorld = null

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
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)

func _enter_tree() -> void:
	if _Instance == null:
		_Instance = self

func _exit_tree() -> void:
	if _Instance == self:
		_Instance = null

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------

func _AddLog(child : Log) -> void:
	if _logs.size() == max_logs:
		remove_child(_logs[0])
	_logs.append(child)

func _RemoveLog(child : Log) -> void:
	var idx : int = _logs.find(child)
	if idx >= 0:
		_logs.remove_at(idx)

# ------------------------------------------------------------------------------
# Public Static Methods
# ------------------------------------------------------------------------------
static func Request_Pickup(item : Node2D) -> void:
	if _Instance != null:
		_Instance.pickup_requested.emit(item)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_child_entered_tree(child : Node) -> void:
	if child is Log:
		_AddLog(child)

func _on_child_exiting_tree(child : Node) -> void:
	if child is Log:
		_RemoveLog(child)


