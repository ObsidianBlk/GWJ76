extends Node2D


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_range(1, 10) var required_chops : int = 2

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _chopped : int = 0
var _log : Log = null

var _is_hovering : bool = false

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _container: Node2D = %Container
@onready var _interactable_top: Interactable = %Interactable_Top
@onready var _interactable_bottom: Interactable = %Interactable_Bottom

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _SetInteractionPlaceable(placeable : bool) -> void:
	_interactable_bottom.interactable = not placeable
	_interactable_bottom.placeable = placeable
	_interactable_top.interactable = not placeable
	_interactable_top.placeable = placeable

func _Hover(dir : int) -> void:
	if _container == null or _is_hovering: return
	_is_hovering = false
	# TODO: Tween Hovering

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_interacted() -> void:
	if _log == null: return
	_chopped += 1
	if _chopped >= required_chops:
		_container.remove_child(_log)
		_log.queue_free()
		_log = null
		# TODO: Spawn LUMBER
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
	_SetInteractionPlaceable(false)
