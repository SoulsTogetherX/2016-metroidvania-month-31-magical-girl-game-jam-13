@tool
class_name GatewayInfo extends Resource


#region Signals (Public)
signal destination_changed
signal state_changed
signal exit_postion_changed
signal direction_changed
#endregion


#region Signals (Private)
signal _cache_finished
#endregion


#region Enums
enum PLAYER_STATES {
	NORMAL,
	JUMPING
}
#endregion


#region External Variables
@export_group("Room")
@export var from_id : int:
	set(val):
		if val == from_id:
			return
		from_id = val
		changed.emit()
		destination_changed.emit()
@export var to_id : int:
	set(val):
		if val == to_id:
			return
		to_id = val
		changed.emit()
		destination_changed.emit()
@export_file("*.tscn") var to_path : String:
	set(val):
		if val == to_path:
			return
		to_path = val
		changed.emit()
		destination_changed.emit()

@export_group("Exit State")
@export var player_state : PLAYER_STATES:
	set(val):
		if val == player_state:
			return
		player_state = val
		changed.emit()
		state_changed.emit()
@export var exit_pos : Vector2:
	set(val):
		if val == exit_pos:
			return
		exit_pos = val
		changed.emit()
		exit_postion_changed.emit()
@export var facing_left : bool:
	set(val):
		if val == facing_left:
			return
		facing_left = val
		changed.emit()
		direction_changed.emit()
#endregion



#region Private Variables
var _room : PackedScene = null
#endregion



#region Virtual Methods
func _init() -> void:
	_room = null
#endregion


#region Public Methods
func cache_room() -> void:
	if Engine.is_editor_hint():
		return
	
	_room = await BackgroundLoader.request_resource(
		to_path,
		"PackedScene"
	)
	_cache_finished.emit()
func get_room() -> PackedScene:
	if Engine.is_editor_hint():
		return
	if !_room:
		await _cache_finished
	return _room
#endregion
