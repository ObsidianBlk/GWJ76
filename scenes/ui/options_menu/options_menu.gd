extends UIControl


# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _options_slideout: SlideoutContainer = %OptionsSlideout


# ------------------------------------------------------------------------------
# "Virtual" Methods
# ------------------------------------------------------------------------------
func on_reveal() -> void:
	#_btn_resume.grab_focus()
	_options_slideout.slide_amount = 1.0
	_options_slideout.slide_in()
	super.on_reveal()

func on_hide() -> void:
	_options_slideout.slide_out()
	await _options_slideout.slide_finished
	super.on_hide()


# ------------------------------------------------------------------------------
# Handler Methods_pause_menu_slideout
# ----------------------------_pause_menu_slideout--------------------------------------------------

func _on_btn_apply_pressed() -> void:
	Settings.save()
	pop_ui()
