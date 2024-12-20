extends Node


# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const GAME_WORLD_SCENE : PackedScene = preload("res://scenes/game_world/game_world.tscn")


# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var pause_menu : StringName = &""

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _game : Node2D = null

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _ui: UILayer = %UI


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_ui.register_action_handler(UIAT.ACTION_QUIT_APPLICATION, _QuitApplication)
	_ui.register_action_handler(UIAT.ACTION_QUIT_GAME, _QuitGame)
	_ui.register_action_handler(UIAT.ACTION_START_SINGLEPLAYER, _StartGame)
	_ui.register_action_handler(UIAT.ACTION_RESUME_GAME, _PauseGame.bind(false))
	_LoadSettings()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		if _game == null:
			_QuitApplication()
		else:
			_PauseGame(not get_tree().paused)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _LoadSettings() -> void:
	if Settings.load() != OK:
		Settings.request_reset()
		Settings.save()

func _QuitApplication() -> void:
	get_tree().quit()

func _QuitGame() -> void:
	if _game == null: return
	remove_child(_game)
	_game.queue_free()
	_game = null
	get_tree().paused = true
	_ui.close_all_ui()
	await _ui.all_ui_hidden
	_ui.open_default_ui()

func _StartGame() -> int:
	if _game != null: return ERR_ALREADY_EXISTS
	var game : Node = GAME_WORLD_SCENE.instantiate()
	if game is Node2D:
		game.process_mode = Node.PROCESS_MODE_PAUSABLE
		_game = game
		add_child(_game)
		_ui.close_all_ui()
		get_tree().paused = false
		return OK
	game.queue_free()
	return ERR_CANT_CREATE

func _PauseGame(pause : bool) -> void:
	if pause == get_tree().paused: return
	if get_tree().paused:
		_ui.close_all_ui()
	else:
		if not pause_menu.is_empty():
			_ui.open_ui(pause_menu)
	get_tree().paused = pause

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
