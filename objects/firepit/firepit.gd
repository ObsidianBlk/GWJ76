@tool
extends Node2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_range(0.0, 1.0) var intensity : float = 1.0:		set=set_intensity

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _gradient_tex : GradientTexture2D = GradientTexture2D.new()

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _fire: Sprite2D = %Fire
@onready var _fire_light: FlickerLight = %FireLight
@onready var _pit: Sprite2D = %Pit


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_intensity(i : float) -> void:
	intensity = i
	_UpdateGradient()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_UpdateGradient()

func _process(_delta: float) -> void:
	_UpdatePit()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateGradient() -> void:
	if _fire == null: return
	if _gradient_tex.gradient == null:
		_gradient_tex.gradient = Gradient.new()
	_gradient_tex.gradient.set_offset(0, 1.0 - intensity)
	_fire.material.set_shader_parameter(&"gradient_texture", _gradient_tex)
	_fire_light.intensity = intensity

func _UpdatePit() -> void:
	if _pit == null or _fire_light == null: return
	if _fire_light.energy < 0.25:
		_pit.region_rect.position.y = 0.0
	elif _fire_light.energy >= 0.25 and _fire_light.energy < 0.75:
		_pit.region_rect.position.y = 16.0
	else:
		_pit.region_rect.position.y = 32.0

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



