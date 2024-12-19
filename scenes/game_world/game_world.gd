extends Node2D
class_name GameWorld

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal pickup_requested(item : Node2D)
signal weather_intensity_changed(intensity : float)

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const DEATH_REASON_CAPTURED : StringName = &"Captured"
const DEATH_REASON_FROZEN : StringName = &"Frozen"

const WEATHER_CURVE : Curve = preload("res://scenes/game_world/weather_curve.tres")
const WEATHER_VARIANCE : float = 0.2

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var object_container : Node2D = null:		set=set_object_container
@export_range(1, 10) var max_logs : int = 5
@export_range(1, 10) var max_planks : int = 4

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _logs : Array[Log] = []
var _planks : Array[Planks] = []


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
func set_object_container(oc : Node2D) -> void:
	if oc != object_container:
		_DisconnectObjectContainer()
		object_container = oc
		_ConnectObjectContainer()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	pass
	#child_entered_tree.connect(_on_child_entered_tree)
	#child_exiting_tree.connect(_on_child_exiting_tree)

func _enter_tree() -> void:
	if _Instance == null:
		_Instance = self

func _exit_tree() -> void:
	if _Instance == self:
		_Instance = null

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ConnectObjectContainer() -> void:
	if object_container == null: return
	if not object_container.child_entered_tree.is_connected(_on_child_entered_tree):
		object_container.child_entered_tree.connect(_on_child_entered_tree)
	if not object_container.child_exiting_tree.is_connected(_on_child_exiting_tree):
		object_container.child_exiting_tree.connect(_on_child_exiting_tree)

func _DisconnectObjectContainer() -> void:
	if object_container == null: return
	if object_container.child_entered_tree.is_connected(_on_child_entered_tree):
		object_container.child_entered_tree.disconnect(_on_child_entered_tree)
	if object_container.child_exiting_tree.is_connected(_on_child_exiting_tree):
		object_container.child_exiting_tree.disconnect(_on_child_exiting_tree)

func _AddLog(child : Log) -> void:
	if object_container == null: return
	if _logs.size() == max_logs:
		object_container.remove_child(_logs[0])
	_logs.append(child)

func _RemoveLog(child : Log) -> void:
	var idx : int = _logs.find(child)
	if idx >= 0:
		_logs.remove_at(idx)

func _AddPlank(child : Planks) -> void:
	if object_container == null: return
	if _planks.size() == max_planks:
		object_container.remove_child(_planks[0])
	_planks.append(child)

func _RemovePlank(child : Planks) -> void:
	var idx : int = _planks.find(child)
	if idx >= 0:
		_planks.remove_at(idx)

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
	elif child is Planks:
		_AddPlank(child)

func _on_child_exiting_tree(child : Node) -> void:
	if child is Log:
		_RemoveLog(child)
	elif child is Planks:
		_RemovePlank(child)

func _on_daytime_changed(hour: float) -> void:
	var point : float = hour / 24.0
	var intensity : float = WEATHER_CURVE.sample(point)
	if intensity > 0.15:
		var variance : float = randf_range(-WEATHER_VARIANCE, WEATHER_VARIANCE)
		intensity += (intensity * variance)
	#print("Hour: ", floor(hour), " | Intensity: ", intensity)
	weather_intensity_changed.emit(intensity)
