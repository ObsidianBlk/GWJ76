extends State
class_name ElfState

# ------------------------------------------------------------------------------
# Signals
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Constants and ENUMs
# ------------------------------------------------------------------------------
const META_FACING : StringName = &"facing"
const FACING_NAME_LEFT: StringName = &"left"
const FACING_NAME_RIGHT: StringName = &"right"
const FACING_NAME_UP: StringName = &"up"
const FACING_NAME_DOWN: StringName = &"down"

const GROUP_INTERACT_COMPONENT : StringName = &"PlayerInteractComp"

# ------------------------------------------------------------------------------
# Export Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
var host : Elf = null
var interact_component : InteractComponent = null

# ------------------------------------------------------------------------------
# Onready Variables
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Setters / Getters
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	await owner.ready
	if owner is Elf:
		host = owner
		var cmps : Array[Node] = get_tree().get_nodes_in_group(GROUP_INTERACT_COMPONENT)
		for cmp : Node in cmps:
			if cmp is InteractComponent and host.is_ancestor_of(cmp):
				interact_component = cmp
				break
		if interact_component == null:
			printerr("Failed to find interact component for ", host.name)
	if host == null:
		printerr("[", name, "]: Null Host Node")
	

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Public Methods
# ------------------------------------------------------------------------------
func is_event_action(event : InputEvent, action_list : Array[StringName]) -> bool:
	for action_name : StringName in action_list:
		if event.is_action(action_name):
			return true
	return false

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

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------



