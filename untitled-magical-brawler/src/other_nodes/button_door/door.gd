@tool
extends Node2D


#region Constants
const DOOR_CLOSED = preload("uid://bocjsvygvymo0")
const DOOR_OPEN = preload("uid://c04llih2idqcb")

const DOOR_CLOSED_X := 0
const DOOR_OPEN_X := 152.0

const DOOR_CLOSED_Z := 0
const DOOR_OPEN_Z := 2
#endregion


#region External Variable
@export var debug_open : bool = false

@export var color : Color = Color.WHITE:
	set(val):
		if val == color:
			return
		color = val
		
		if is_node_ready():
			_update_color()
@export var event_name : StringName
#endregion


#region OnReady Variable
@onready var _door: Sprite2D = %Door
@onready var _front_frame: Sprite2D = %FrontFrame

@onready var _door_collision: CollisionShape2D = %DoorStopper
#endregion



#region Virtual Methods
func _ready() -> void:
	_update_color()
	_update_door()
	
	if Engine.is_editor_hint():
		return
	if debug_open:
		queue_free()
		return
	
	var control := Global.local_controller
	if control is RoomManager:
		control.events_changed.connect(_update_door)
#endregion


#region Private Methods
func _update_color() -> void:
	_door.modulate = color
func _update_door() -> void:
	if Engine.is_editor_hint():
		_front_frame.z_index = DOOR_CLOSED_Z
		
		_door.position.x = DOOR_CLOSED_X
		_door.z_index = DOOR_CLOSED_Z
		_door.texture = DOOR_CLOSED
		_door_collision.set_deferred(
			"disabled", false
		)
		return
	
	var control := Global.local_controller
	if control is RoomManager:
		if control.saw_event(event_name):
			_front_frame.z_index = DOOR_OPEN_Z
			
			_door.position.x = DOOR_OPEN_X
			_door.z_index = DOOR_OPEN_Z
			_door.texture = DOOR_OPEN
			_door_collision.set_deferred(
				"disabled", true
			)
			return
		
		_front_frame.z_index = DOOR_CLOSED_Z
		
		_door.position.x = DOOR_CLOSED_X
		_door.z_index = DOOR_CLOSED_Z
		_door.texture = DOOR_CLOSED
		_door_collision.set_deferred(
			"disabled", false
		)
#endregion
