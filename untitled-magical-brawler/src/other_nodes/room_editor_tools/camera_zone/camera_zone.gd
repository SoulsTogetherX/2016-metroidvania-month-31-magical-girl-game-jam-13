@tool
class_name CameraZone2D extends Area2D


#region Constants
const DEFAULT_SHAPE_SIZE := Vector2(100, 500)

const PHANTOM_CAMERA_NAME := "PhantomCamera2D"
#endregion


#region Private Variables
var _phantom_camera : PhantomCamera2D
#endregion



#region Virtual Methods
func _init() -> void:
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = Constants.COLLISION.PLAYER
	
	body_entered.connect(_on_player_enter.unbind(1))
func _ready() -> void:
	EditorUtilities.confirmed_child(
		self,
		&"_phantom_camera",
		PHANTOM_CAMERA_NAME,
		_create_phantom_camera,
		func(_node): pass,
		0
	)
	_phantom_camera.add_to_group(
		GlobalLabels.objects.CAMERA_ZONE_GROUP_NAME
	)
#endregion


#region Private Methods (Confirmed Children)
func _create_phantom_camera() -> PhantomCamera2D:
	var node := PhantomCamera2D.new()
	
	node.zoom = Vector2(0.3, 0.3)
	node.tween_on_load = false
	node.inactive_update_mode = PhantomCamera2D.InactiveUpdateMode.NEVER
	
	return node
#endregion


#region Private Methods (Signal)
func _on_player_enter() -> void:
	CameraZoneManager.focus_camera(_phantom_camera)
#endregion
