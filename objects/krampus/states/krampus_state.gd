extends State
class_name KrampusState


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const META_FACING : StringName = &"facing"
const META_TIME : StringName = &"time"

const FACING_NAME_LEFT: StringName = &"left"
const FACING_NAME_RIGHT: StringName = &"right"
const FACING_NAME_UP: StringName = &"up"
const FACING_NAME_DOWN: StringName = &"down"

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var host : Krampus = null

# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	await owner.ready
	if owner is Krampus:
		host = owner
	if host == null:
		printerr("[", name, "]: Null Host Node")

# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func set_facing_from_velocity() -> void:
	if host == null: return
	if host.velocity.is_equal_approx(Vector2.ZERO): return
	var x : float = abs(host.velocity.x)
	var y : float = abs(host.velocity.y)
	if x > y:
		host.set_meta(META_FACING, Vector2i(signf(host.velocity.x), 0))
	elif y > x:
		host.set_meta(META_FACING, Vector2i(0.0, signf(host.velocity.y)))

func facing_name() -> StringName:
	if host != null:
		var facing : Vector2i = host.get_meta(META_FACING, Vector2i.DOWN)
		if facing.x < 0:
			return FACING_NAME_LEFT
		if facing.x > 0:
			return FACING_NAME_RIGHT
		if facing.y < 0:
			return FACING_NAME_UP
	return FACING_NAME_DOWN

func play_animation(anim_name : StringName) -> void:
	if host == null: return
	var facing_name : StringName = facing_name()
	if facing_name == FACING_NAME_LEFT or facing_name == FACING_NAME_RIGHT:
		host.flip(facing_name == FACING_NAME_LEFT)
		host.play_animation(&"%s_side"%[anim_name])
	else:
		host.flip(false)
		host.play_animation(&"%s_%s"%[anim_name, facing_name])

func is_playing(anim_name : StringName) -> bool:
	if host == null: return false
	var cur_anim : StringName = host.get_animation()
	return cur_anim.begins_with(anim_name)
