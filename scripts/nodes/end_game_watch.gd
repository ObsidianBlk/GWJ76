extends Node
class_name EndGameWatch

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal escaped()

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export_range(1, 12) var days_to_rescue : int = 3
@export var santa : Santa = null:					set=set_santa
@export var landing_point : Marker2D = null
@export var walking_point : Marker2D = null
@export var flying_point : Marker2D = null

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _last_hour : float = 0.0
var _days : int = 0

var _end_game_part : int = 0

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_santa(s : Santa) -> void:
	if santa != null:
		if santa.destination_reached.is_connected(_on_santa_destination_reached):
			santa.destination_reached.disconnect(_on_santa_destination_reached)
		if santa.elf_interacted.is_connected(_on_santa_elf_interacted):
			santa.elf_interacted.disconnect(_on_santa_elf_interacted)
	santa = s
	if santa != null:
		if not santa.destination_reached.is_connected(_on_santa_destination_reached):
			santa.destination_reached.connect(_on_santa_destination_reached)
		if not santa.elf_interacted.is_connected(_on_santa_elf_interacted):
			santa.elf_interacted.connect(_on_santa_elf_interacted)

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _IsValid() -> bool:
	if santa == null: return false
	if landing_point == null: return false
	if walking_point == null: return false
	if flying_point == null: return false
	return true

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func set_hour(h : float) -> void:
	if not _IsValid(): return
	var hour : float = floor(h)
	if _end_game_part == 0:
		santa.z_index = 2
		santa.fly_to(landing_point.global_position, 4.0)
	#if hour < 1.0 and _last_hour >= 1.0:
		#_days += 1
		#if _days == days_to_rescue:
			#print("SANTA INCOMING")
			#santa.z_index = 2
			#santa.fly_to(landing_point.global_position, 4.0)
	_last_hour = hour

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_santa_destination_reached() -> void:
	match _end_game_part:
		0: # Finished Landing
			santa.z_index = 0
			santa.interactable(true)
			_end_game_part = 1
		1: # Finished Walking
			_end_game_part = 2
			santa.z_index = 2
			santa.fly_to(flying_point.global_position, 4.0)
		2: # Finished leaving level
			escaped.emit()

func _on_santa_elf_interacted() -> void:
	santa.walk_to(walking_point.global_position, 3.0)

