@tool
class_name GatewayExitMarker2D extends Marker2D


#region Signals
signal position_changed
signal direction_changed
#endregion


#region Constants
const HOLOGRAM_RESOURCE_PATH := "res://assets/entities/player/resources/player_sprite_frames.tres"
const HOLOGRAM_OFFSET := -224.0
const HOLOGRAM_MODULATE := Color(0.7, 0.7, 0.2, 0.8)

const SNAP_RAYCAST_LENGTH := 2000.0
#endregion


#region External Variables
@export_tool_button("Snap to ground") var snap_to_ground := _snap_to_ground
@export var facing_left : bool:
	set(val):
		if val == facing_left:
			return
		facing_left = val
		direction_changed.emit()
		_change_direction()
#endregion


#region Private Variables
var _hologram : AnimatedSprite2D
#endregion



#region Virtual Methods
func _ready() -> void:
	if !Engine.is_editor_hint():
		return
	set_notify_transform(true)
	
	_hologram = AnimatedSprite2D.new()
	_hologram.offset.y = HOLOGRAM_OFFSET
	_hologram.sprite_frames = load(HOLOGRAM_RESOURCE_PATH)
	_hologram.modulate = HOLOGRAM_MODULATE
	add_child(_hologram)
	
	_change_state()
	_change_direction()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_TRANSFORM_CHANGED:
			position_changed.emit()
#endregion


#region Private Methods
func _snap_to_ground() -> void:
	var result := EditorUtilities.raycast_ground(
		self, SNAP_RAYCAST_LENGTH
	)
	
	if result.get(&"collider", null) != null:
		global_position.y = result.position.y

func _change_state() -> void:
	_hologram.animation = &"idle"
	_hologram.frame = 0

func _change_direction() -> void:
	if !_hologram:
		return
	
	_hologram.scale.x = -1 if facing_left else 1
#endregion
