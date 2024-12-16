extends UIControl


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var options_menu : StringName = &""

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _main_menu_slideout: SlideoutContainer = %MainMenuSlideout

@onready var _btn_start_game: Button = %BTN_StartGame


# ------------------------------------------------------------------------------
# "Virtual" Methods
# ------------------------------------------------------------------------------
func on_reveal() -> void:
	_btn_start_game.grab_focus()
	_main_menu_slideout.slide_amount = 1.0
	_main_menu_slideout.slide_in()
	super.on_reveal()

func on_hide() -> void:
	_main_menu_slideout.slide_out()
	await _main_menu_slideout.slide_finished
	super.on_hide()


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------

func _on_btn_start_game_pressed() -> void:
	request(UIAT.ACTION_START_SINGLEPLAYER)

func _on_btn_options_pressed() -> void:
	if not options_menu.is_empty():
		swap_ui(options_menu)

func _on_btn_quit_pressed() -> void:
	request(UIAT.ACTION_QUIT_APPLICATION)
