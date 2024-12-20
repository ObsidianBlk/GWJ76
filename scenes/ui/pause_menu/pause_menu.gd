extends UIControl

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var options_menu : StringName = &""

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _pause_menu_slideout: SlideoutContainer = %PauseMenuSlideout
@onready var _btn_resume: Button = %BTN_Resume

# ------------------------------------------------------------------------------
# "Virtual" Methods
# ------------------------------------------------------------------------------
func on_reveal() -> void:
	_btn_resume.grab_focus()
	_pause_menu_slideout.slide_amount = 1.0
	_pause_menu_slideout.slide_in()
	super.on_reveal()

func on_hide() -> void:
	_pause_menu_slideout.slide_out()
	await _pause_menu_slideout.slide_finished
	super.on_hide()


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_btn_resume_pressed() -> void:
	request(UIAT.ACTION_RESUME_GAME)

func _on_btn_options_pressed() -> void:
	if not options_menu.is_empty():
		swap_ui(options_menu, false, {OPTION_PREVIOUS_MENU: name})

func _on_btn_quit_pressed() -> void:
	request(UIAT.ACTION_QUIT_GAME)
