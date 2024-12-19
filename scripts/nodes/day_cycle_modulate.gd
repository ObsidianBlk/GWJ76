@tool
extends CanvasModulate
class_name DayCycleModulate


# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal daytime_changed(hour : float)

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var seconds_per_day : float = 1.0:				set=set_seconds_per_day
@export_range(0.0, 24.0) var hour : float = 6.0:		set=set_hour
@export var color_gradient : Gradient = null:			set=set_color_gradient


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _current_time : float = 0.0

# ------------------------------------------------------------------------------
# Setters
# ------------------------------------------------------------------------------
func set_seconds_per_day(spd : float) -> void:
	if spd >= 1.0:
		seconds_per_day = spd

func set_hour(h : float) -> void:
	if h >= 0.0 and h <= 24.0:
		hour = h
		_current_time = (hour / 24.0) * seconds_per_day
		_UpdateModulation()

func set_color_gradient(g : Gradient) -> void:
	_DisconnectGradient()
	color_gradient = g
	_ConnectGradient()
	_UpdateModulation()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_UpdateModulation()

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	_current_time += delta
	if _current_time >= seconds_per_day:
		_current_time = fmod(_current_time, seconds_per_day)
	hour = (_current_time / seconds_per_day) * 24.0
	daytime_changed.emit(hour)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _ConnectGradient() -> void:
	if color_gradient == null: return
	if not color_gradient.changed.is_connected(_on_gradient_changed):
		color_gradient.changed.connect(_on_gradient_changed)

func _DisconnectGradient() -> void:
	if color_gradient == null: return
	if color_gradient.changed.is_connected(_on_gradient_changed):
		color_gradient.changed.disconnect(_on_gradient_changed)

func _UpdateModulation() -> void:
	if color_gradient == null:
		modulate = Color.WHITE
		return
	color = color_gradient.sample(_current_time / seconds_per_day)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func _on_gradient_changed() -> void:
	_UpdateModulation()
