@tool
extends Node2D

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const INTERACTION_INTENSITY : float = 0.2

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_range(0.0, 1.0) var intensity : float = 1.0:		set=set_intensity
@export var heater_component : HeaterComponent = null:		set=set_heater_component
@export var interactable : Interactable = null:				set=set_interactable

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _gradient_tex : GradientTexture2D = GradientTexture2D.new()
var _original_heater_value : float = 0.0

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
	_UpdateIntensity()

func set_heater_component(hc : HeaterComponent) -> void:
	if hc != heater_component:
		if heater_component != null:
			heater_component.heat_value = _original_heater_value
		heater_component = hc
		if heater_component != null:
			_original_heater_value = heater_component.heat_value
		_UpdateIntensity()

func set_interactable(i : Interactable) -> void:
	if interactable != i:
		_DisconnectInteractable()
		interactable = i
		_ConnectInteractable()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_UpdateIntensity()

func _process(_delta: float) -> void:
	_UpdatePit()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ConnectInteractable() -> void:
	if interactable == null: return
	if not interactable.interacted.is_connected(_on_interacted):
		interactable.interacted.connect(_on_interacted)

func _DisconnectInteractable() -> void:
	if interactable == null: return
	if interactable.interacted.is_connected(_on_interacted):
		interactable.interacted.disconnect(_on_interacted)

func _UpdateIntensity() -> void:
	if _fire == null: return
	if _gradient_tex.gradient == null:
		_gradient_tex.gradient = Gradient.new()
	_gradient_tex.gradient.set_offset(0, 1.0 - intensity)
	_fire.material.set_shader_parameter(&"gradient_texture", _gradient_tex)
	_fire_light.intensity = intensity
	
	if heater_component != null and not Engine.is_editor_hint():
		heater_component.heat_value = lerp(0.0, _original_heater_value, intensity)

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
func _on_interacted() -> void:
	print("Interacted with FIRE!!")
	intensity = clamp(intensity + INTERACTION_INTENSITY, 0.0, 1.0)
