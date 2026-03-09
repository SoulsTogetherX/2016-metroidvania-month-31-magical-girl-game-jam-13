@tool
class_name CameraZone2D extends Area2D


#region Constants
const DEFAULT_SHAPE_SIZE := Vector2(500, 500)

const PHANTOM_CAMERA_NAME := "PhantomCamera2D"
const PHANTOM_COllISION_NAME := "PhantomCollison"
#endregion


#region Private Variables
var _phantom_camera : PhantomCamera2D
#endregion



#region Virtual Methods
func _init() -> void:
	monitoring = false
	monitorable = false
	collision_layer = 0
	collision_mask = Constants.COLLISION.PLAYER
	z_index = 100
	
	body_entered.connect(_on_player_enter)
func _ready() -> void:
	z_index = 1
	
	EditorUtilities.confirmed_child.call_deferred(
		self,
		&"",
		PHANTOM_COllISION_NAME,
		_create_phantom_collision,
		func(_node): pass,
		0
	)
	EditorUtilities.confirmed_child.call_deferred(
		self,
		&"_phantom_camera",
		PHANTOM_CAMERA_NAME,
		_create_phantom_camera,
		_settup_phantom_camera,
		1
	)
	
	if Engine.is_editor_hint():
		return
	_after_ready()

func _after_ready() -> void:
	monitoring = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	monitoring = true
#endregion


#region Private Methods (Confirmed Children)
func _create_phantom_collision() -> CollisionShape2D:
	var node := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = DEFAULT_SHAPE_SIZE
	
	node.shape = rect
	return node

func _create_phantom_camera() -> PhantomCamera2D:
	var node := PhantomCamera2D.new()
	node.zoom = Vector2(0.3, 0.3)
	
	return node
func _settup_phantom_camera(val : PhantomCamera2D) -> void:
	val.tween_on_load = false
	val.inactive_update_mode = PhantomCamera2D.InactiveUpdateMode.NEVER
	val.noise_emitter_layer = 1
	
	val.add_to_group(
		GlobalLabels.objects.CAMERA_ZONE_GROUP_NAME
	)
#endregion


#region Private Methods (Signal)
func _on_player_enter(player : Player) -> void:
	if !(player is Player):
		return
	CameraZoneManager.focus_camera(_phantom_camera)
#endregion
