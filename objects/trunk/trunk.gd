extends Node2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const THROW_CURVE : Curve = preload("res://objects/trunk/trunk_throw_curve.tres")
const LOG_SCENE : PackedScene = preload("res://objects/log/log.tscn")

const MIN_THROW_DISTANCE : float = 8.0
const MAX_THROW_DISTANCE : float = 32.0

const MIN_THROW_HEIGHT : float = 4.0
const MAX_THROW_HEIGHT : float = 8.0

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_range(1, 10) var chops_per_log : int = 3
@export var log_container : Node2D = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _chop_count : int = 0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _particles: GPUParticles2D = %Particles


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _SpawnLog(dir : StringName) -> void:
	if log_container == null: return
	var log : Node2D = LOG_SCENE.instantiate()
	if log == null: return
	var throw_cmp : ThrowComponent = ThrowComponent.new()
	throw_cmp.drop_curve = THROW_CURVE
	throw_cmp.direction = ThrowComponent.Direction.LEFT
	if dir == &"LEFT":
		throw_cmp.direction = ThrowComponent.Direction.RIGHT
	throw_cmp.distance = randf_range(MIN_THROW_DISTANCE, MAX_THROW_DISTANCE)
	throw_cmp.height = randf_range(MIN_THROW_HEIGHT, MAX_THROW_HEIGHT)
	log.add_child(throw_cmp)
	log_container.add_child(log)
	log.position = position + Vector2(0.0, 10.0)
	log.position.y += randf_range(-4.0, 4.0)
	
	throw_cmp.start()

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_interacted(dir : StringName) -> void:
	_particles.emitting = true
	_chop_count += 1
	if _chop_count == chops_per_log:
		_chop_count = 0
		_SpawnLog(dir)
