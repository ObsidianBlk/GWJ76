extends Node


# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------
signal fade_changed(p : float)
signal fade_complete()

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
var _game : GameWorld = null
var _fade_progress : float = 0.0:			set=_set_fade_progress
var _fading : bool = false

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
	get_tree().paused = true
	_ui.close_all_ui()
	_FadeTo(1.0, 1.0)
	_ui.all_ui_hidden
	await fade_complete
	_RemoveGameWorld()
	await _FadeTo(0.0, 1.0)
	_ui.open_default_ui()

func _RemoveGameWorld() -> void:
	if _game == null: return
	remove_child(_game)
	_game.game_ended.disconnect(_on_game_ended)
	_game.queue_free()
	_game = null

func _StartGame() -> void:
	if _game != null: return
	await _FadeTo(1.0, 1.0)
	_AddGameWorld()
	_FadeTo(0.0, 1.0)

func _AddGameWorld() -> int:
	if _game != null: return ERR_ALREADY_EXISTS
	var game : Node = GAME_WORLD_SCENE.instantiate()
	if game is GameWorld:
		game.process_mode = Node.PROCESS_MODE_PAUSABLE
		_game = game
		_game.game_ended.connect(_on_game_ended)
		add_child(_game)
		_ui.close_all_ui()
		get_tree().paused = false
		return OK
	if game != null:
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

func _set_fade_progress(p : float) -> void:
	_fade_progress = p
	fade_changed.emit(_fade_progress)

func _FadeTo(target : float, duration : float) -> void:
	if _fading == true: return
	_fading = true
	
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "_fade_progress", target, duration)
	await tween.finished
	_fading = false
	fade_complete.emit()

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_game_ended(reason : StringName) -> void:
	pass
