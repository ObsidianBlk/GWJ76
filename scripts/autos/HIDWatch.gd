extends Node

# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const KEYBOARD_INTERACT_ICON_PATH : String = "res://assets/graphics/hid_icons/key_e.png"
const JOYPAD_INTERACT_ICON_PATH : String = "res://assets/graphics/hid_icons/joy_btn_a.png"

const KEYBOARD_INTERACT_ICON : Texture2D = preload(KEYBOARD_INTERACT_ICON_PATH)
const JOYPAD_INTERACT_ICON : Texture2D = preload(JOYPAD_INTERACT_ICON_PATH)

enum HIDType {KBM=0, Joypad=1}

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _last_hid : HIDType = HIDType.KBM

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		_last_hid = HIDType.KBM
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		_last_hid = HIDType.Joypad

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func get_interact_icon() -> Texture2D:
	match _last_hid:
		HIDType.KBM:
			return KEYBOARD_INTERACT_ICON
		HIDType.Joypad:
			return JOYPAD_INTERACT_ICON
	return null

func get_interact_icon_path() -> String:
	match _last_hid:
		HIDType.KBM:
			return KEYBOARD_INTERACT_ICON_PATH
		HIDType.Joypad:
			return JOYPAD_INTERACT_ICON_PATH
	return ""
