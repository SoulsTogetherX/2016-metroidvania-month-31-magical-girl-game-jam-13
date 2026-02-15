class_name ActionCacheComponent extends Node


#region Enum
enum ACTION_STATE {
	NONE     = 0b00,
	STARTED  = 0b01,
	FINISHED = 0b10,
	HELD     = 0b11,
}

enum UPDATE_CALLBACK {
	NONE     = 0b00,
	PROCESS  = 0b01,
	PHYSICS = 0b10
}
#endregion


#region External Variables
@export var update_rate : UPDATE_CALLBACK = UPDATE_CALLBACK.PROCESS:
	set(val):
		if val == update_rate:
			return
		update_rate = val
		
		if is_node_ready():
			_refresh_update_rate()
#endregion


#region Private Variables
var _action_toggle : Array[bool]
var _action_state : Array[int]
var _action_cache : Dictionary[StringName, int]

var _dir_value : Array[Vector2]
var _dir_cache : Dictionary[StringName, int]
#endregion



#region Virtual Methods
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			_refresh_update_rate()
#endregion


#region Private Methods (Helper)
func _refresh_update_rate() -> void:
	if get_tree().process_frame.is_connected(update_all_cache):
		get_tree().process_frame.disconnect(update_all_cache)
	if get_tree().physics_frame.is_connected(update_all_cache):
		get_tree().physics_frame.disconnect(update_all_cache)
	
	match update_rate:
		UPDATE_CALLBACK.PROCESS:
			get_tree().process_frame.connect(update_all_cache)
		UPDATE_CALLBACK.PHYSICS:
			get_tree().physics_frame.connect(update_all_cache)

func _get_action_index(action_name : StringName) -> int:
	return _action_cache.get(action_name, -1)
func _get_direction_index(dir_name : StringName) -> int:
	return _dir_cache.get(dir_name, -1)

func _insert_action(action_name : StringName, toggle : bool) -> void:
	_action_cache[action_name] = _action_toggle.size()
	_action_toggle.push_back(toggle)
	
	if toggle:
		_action_state.push_back(ACTION_STATE.STARTED)
		return
	_action_state.push_back(ACTION_STATE.NONE)
func _insert_direction(dir_name : StringName, dir : Vector2) -> void:
	_dir_cache[dir_name] = _dir_value.size()
	_dir_value.push_back(dir)
#endregion


#region Public Methods (Action Cache)
func clear_caches() -> void:
	_action_toggle.clear()
	_action_state.clear()
	_action_cache.clear()
	
	_dir_value.clear()
	_dir_cache.clear()

func update_all_cache() -> void:
	_dir_value.fill(Vector2.ZERO)
	for idx : int in range(_action_toggle.size()):
		_action_state[idx] <<= 1
		if _action_toggle[idx]:
			_action_state[idx] |= 1

func set_action(action_name : StringName, toggle : bool) -> void:
	var idx := _get_action_index(action_name)
	if idx == -1:
		_insert_action(action_name, toggle)
		return
	
	_action_toggle[idx] = toggle
	if toggle:
		_action_state[idx] |= int(ACTION_STATE.STARTED)
func set_direction(dir_name : StringName, dir : Vector2) -> void:
	var idx := _get_direction_index(dir_name)
	if idx == -1:
		_insert_direction(dir_name, dir)
		return
	_dir_value[idx] = dir

func is_action_toggled(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	return _action_toggle[idx]
#endregion


#region Public Methods (Action Checks)
func is_action(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	
	return ACTION_STATE.NONE != (_action_state[idx] & ACTION_STATE.HELD)
func is_action_held(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	
	return ACTION_STATE.HELD != (_action_state[idx] & ACTION_STATE.HELD)
func is_action_started(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	
	return ACTION_STATE.STARTED != (_action_state[idx] & ACTION_STATE.HELD)
func is_action_finished(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	
	return ACTION_STATE.FINISHED != (_action_state[idx] & ACTION_STATE.HELD)

func get_direction(action_name : StringName) -> Vector2:
	var idx := _get_direction_index(action_name)
	if idx == -1:
		return Vector2.ZERO
	return _dir_value[idx]
#endregion
