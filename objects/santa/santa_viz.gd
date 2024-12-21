@tool
extends Node2D
class_name SantaViz

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const ANIM_IDLE : StringName = &"idle"
const ANIM_BLINK : StringName = &"idle_blink"
const ANIM_FLIGHT : StringName = &"flight"

const ANIM_BOB : StringName = &"idle_bob"
const ANIM_WALK : StringName = &"walk"

const IDLE_DELAY : float = 1.0

enum Viz {IDLE=0, FLIGHT=1, WALK=2}

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------
@export var state : Viz = Viz.IDLE

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var _weighted_actions = WeightedRandomCollection.new([
	{&"ID":ANIM_IDLE, &"Weight":50.0},
	{&"ID":ANIM_BLINK, &"Weight":10.0},
	{&"ID":ANIM_BOB, &"Weight":10.0}
])

var _santa_delay : float = 0.0
var _deer_delay : Array[float] = [0.0, 0.0, 0.0]

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------
@onready var _santa: AnimatedSprite2D = $ASprite_Santa
@onready var _deer : Array[AnimatedSprite2D] = [
	$ASprite_Deer_01,
	$ASprite_Deer_02,
	$ASprite_Deer_03
]

# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------
func set_state(s : Viz) -> void:
	if s != state:
		state = s
		if state == Viz.IDLE:
			_ResetIdleState()
		

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	_santa.animation_finished.connect(_on_animation_finished.bind(_santa))
	for spr : AnimatedSprite2D in _deer:
		spr.animation_finished.connect(_on_animation_finished.bind(spr))


func _process(delta: float) -> void:
	if _santa == null: return
	match state:
		Viz.IDLE:
			if _santa_delay <= 0.0:
				var anim : StringName = _weighted_actions.get_random()
				if anim == ANIM_BLINK:
					_santa.play(anim)
				_santa_delay = IDLE_DELAY
			else:
				_santa_delay -= delta
			
			for d : int in range(_deer.size()):
				if _deer_delay[d] <= 0.0:
					var anim : StringName = _weighted_actions.get_random()
					if anim != ANIM_IDLE:
						_deer[d].play(anim)
					_deer_delay[d] = IDLE_DELAY
				else:
					_deer_delay[d] -= delta
		Viz.FLIGHT:
			_PlayIfNot(_santa, ANIM_FLIGHT)
			for spr : AnimatedSprite2D in _deer:
				_PlayIfNot(spr, ANIM_FLIGHT)
		Viz.WALK:
			_PlayIfNot(_santa, ANIM_IDLE)
			for spr : AnimatedSprite2D in _deer:
				_PlayIfNot(spr, ANIM_WALK)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _PlayIfNot(spr : AnimatedSprite2D, anim_name : StringName) -> void:
	if spr.animation != anim_name:
		spr.play(anim_name)

func _ResetIdleState() -> void:
	if _santa == null: return
	_santa.play(ANIM_IDLE)
	for spr : AnimatedSprite2D in _deer:
		spr.play(ANIM_IDLE)

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_animation_finished(spr : AnimatedSprite2D) -> void:
	if spr.animation.begins_with(ANIM_IDLE) and spr.animation != ANIM_IDLE:
		spr.play(ANIM_IDLE)


