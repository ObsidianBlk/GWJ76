extends Node2D


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const PLANK_SCENE : PackedScene = preload("res://objects/planks/planks.tscn")
const THROW_CURVE : Curve = preload("res://objects/wood_station/throw_curve.tres")

const MIN_THROW_DISTANCE : float = 8.0
const MAX_THROW_DISTANCE : float = 32.0

const MIN_THROW_HEIGHT : float = 4.0
const MAX_THROW_HEIGHT : float = 8.0

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_range(1, 10) var required_chops : int = 2
@export var plank_container : Node2D = null
@export var message_place : String = "Place"
@export var message_use : String = "Use"

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _chopped : int = 0
var _log : Log = null

var _is_hovering : bool = false
var _container_origin_y : float = 0.0
var _direction_down : bool = false

var _throw_weight : WeightedRandomCollection = WeightedRandomCollection.new([
	{"ID":&"LEFT", "Weight":30.0},
	{"ID":&"RIGHT", "Weight":30.0},
	{"ID":&"GIVEN", "Weight":30.0}
])

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _container: Node2D = %Container
@onready var _interactable_top: Interactable = %Interactable_Top
@onready var _interactable_bottom: Interactable = %Interactable_Bottom

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_container_origin_y = _container.position.y
	_Hover()
	_SetInteractionPlaceable(true)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _SetInteractionPlaceable(placeable : bool) -> void:
	_interactable_bottom.interactable = not placeable
	_interactable_bottom.placeable = placeable
	_interactable_bottom.message = message_place if placeable else message_use
	_interactable_top.interactable = not placeable
	_interactable_top.placeable = placeable
	_interactable_top.message = message_place if placeable else message_use

func _Hover() -> void:
	if _container == null or _is_hovering: return
	_is_hovering = true
	
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	if _direction_down:
		tween.tween_property(_container, "position:y", _container_origin_y, 1.0)
	else:
		tween.tween_property(_container, "position:y", _container_origin_y-8, 1.0)
	_direction_down = not _direction_down
	
	await tween.finished
	_is_hovering = false
	_Hover.call_deferred()

func _SpawnPlank(direction : StringName) -> void:
	if plank_container == null: return
	var plank : Planks = PLANK_SCENE.instantiate()
	if plank == null: return
	
	var throw_cmp : ThrowComponent = ThrowComponent.new()
	throw_cmp.drop_curve = THROW_CURVE
	throw_cmp.direction = ThrowComponent.Direction.UP
	var dir : StringName = _throw_weight.get_random()
	if dir == &"GIVEN": dir = direction
	match dir:
		&"LEFT":
			throw_cmp.direction = ThrowComponent.Direction.LEFT
		&"RIGHT":
			throw_cmp.direction = ThrowComponent.Direction.RIGHT
		&"DOWN":
			throw_cmp.direction = ThrowComponent.Direction.DOWN
	throw_cmp.distance = randf_range(MIN_THROW_DISTANCE, MAX_THROW_DISTANCE)
	throw_cmp.height = randf_range(MIN_THROW_HEIGHT, MAX_THROW_HEIGHT)
	
	plank.add_child(throw_cmp)
	plank_container.add_child(plank)
	plank.position = _container.global_position
	throw_cmp.start()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_interacted(direction : StringName) -> void:
	if _log == null: return
	_chopped += 1
	if _chopped >= required_chops:
		_container.remove_child(_log)
		_log.queue_free()
		_log = null
		
		_SpawnPlank(direction)
		_SpawnPlank(direction)
		_SetInteractionPlaceable(true)

func _on_placed(item : Node2D) -> void:
	if _log != null or not item is Log:
		# We're rolling under the assumption that we keep any node "placed".
		#  So, if that node isn't a log, just free it and move on.
		item.queue_free()
		return
	
	_container.add_child(item)
	item.position = Vector2.ZERO
	_log = item
	if _log.interactable != null:
		_log.interactable.interactable = false
	_SetInteractionPlaceable(false)
	_chopped = 0
