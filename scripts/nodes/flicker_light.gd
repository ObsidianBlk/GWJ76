@tool
extends PointLight2D
class_name FlickerLight

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
@export_range(0.0, 16.0) var base_energy : float = 1.0:		set=set_base_energy
@export_range(0.0, 1.0) var min_strength : float = 0.5:		set=set_min_strength
@export_range(0.0, 1.0) var max_strength : float = 1.0:		set=set_max_strength
@export var noise : FastNoiseLite = null
@export var enable_in_engine : bool = true:					set=set_enable_in_engine

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _time : float = 0.0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
func _ready() -> void:
	_UpdateEnergy()

# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_intensity(i : float) -> void:
	intensity = i
	_UpdateEnergy()

func set_base_energy(e : float) -> void:
	if e >= 0 and e <= 16.0:
		base_energy = e
		_UpdateEnergy()

func set_min_strength(s : float) -> void:
	if s >= 0 and s <= 1.0:
		min_strength = s
		if min_strength > max_strength:
			max_strength = min_strength

func set_max_strength(s : float) -> void:
	if s >= 0 and s <= 1.0:
		max_strength = s
		if max_strength < min_strength:
			min_strength = max_strength

func set_enable_in_engine(e : bool) -> void:
	enable_in_engine = e
	_UpdateEnergy()

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if not enable_in_engine: return
	_time = _time + delta * 50.0
	_UpdateEnergy()

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _UpdateEnergy() -> void:
	var strength : float = 1.0
	if noise != null and enable_in_engine:
		var noise_value : float = (noise.get_noise_1d(_time) + 1.0) / 2.0
		strength = min(max_strength, max(min_strength, noise_value))
	strength *= intensity
	energy = base_energy * strength

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



