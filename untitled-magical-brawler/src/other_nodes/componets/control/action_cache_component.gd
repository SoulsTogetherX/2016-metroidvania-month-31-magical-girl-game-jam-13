@tool
class_name ActionCacheComponent extends Node


#region Signals
signal action_started(action_name : StringName)
signal action_finished(action_name : StringName)
#endregion


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
@export_group("Settings")
@export var update_rate : UPDATE_CALLBACK = UPDATE_CALLBACK.PROCESS:
	set(val):
		if val == update_rate:
			return
		update_rate = val
		
		if is_node_ready():
			_refresh_update_rate()
#endregion


#region Private Variables
var _actions : Array[Action]
var _action_cache : Dictionary[StringName, int]

var _states : Array[Variant]
var _state_cache : Dictionary[StringName, int]
#endregion



#region Virtual Methods
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			_refresh_update_rate()
			update_configuration_warnings()
#endregion


#region Private Methods (Helper)
func _refresh_update_rate() -> void:
	if get_tree().process_frame.is_connected(update_actions_cache):
		get_tree().process_frame.disconnect(update_actions_cache)
	if get_tree().physics_frame.is_connected(update_actions_cache):
		get_tree().physics_frame.disconnect(update_actions_cache)
	
	match update_rate:
		UPDATE_CALLBACK.PROCESS:
			get_tree().process_frame.connect(update_actions_cache)
		UPDATE_CALLBACK.PHYSICS:
			get_tree().physics_frame.connect(update_actions_cache)

func _get_action_index(action_name : StringName) -> int:
	return _action_cache.get(action_name, -1)
func _get_state_index(dir_name : StringName) -> int:
	return _state_cache.get(dir_name, -1)
#endregion


#region Public Methods (Action Cache)
func clear_caches() -> void:
	_actions.clear()
	_action_cache.clear()
	
	_states.clear()
	_state_cache.clear()

func update_actions_cache() -> void:
	for action : Action in _actions:
		action.state <<= 1
		
		if action.toggle:
			action.state |= 1
			continue
		action_finished.emit(action.action_name)

func set_action(action_name : StringName, toggle : bool) -> void:
	var idx := _get_action_index(action_name)
	if idx == -1:
		_action_cache[action_name] = _actions.size()
		_actions.push_back(Action.new(action_name, toggle))
		return
	
	var action := _actions[idx]
	if action.toggle == toggle:
		return
	
	action.toggle = toggle
	if toggle:
		action.state |= int(ACTION_STATE.STARTED)
		action_started.emit(action_name)
	
	
func set_state(state_name : StringName, val : Variant) -> void:
	var idx := _get_state_index(state_name)
	if idx == -1:
		_state_cache[state_name] = _states.size()
		_states.push_back(val)
		return
	_states[idx] = val

func is_action_toggled(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	return _actions[idx].toggle
#endregion


#region Public Methods (Action Checks)
func is_action(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	return _actions[idx].used()
func is_action_held(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	return _actions[idx].compair(ACTION_STATE.HELD)
func is_action_started(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	return _actions[idx].compair(ACTION_STATE.STARTED)
func is_action_finished(action_name : StringName) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return false
	return _actions[idx].compair(ACTION_STATE.FINISHED)

func get_state(state_name : StringName) -> Variant:
	var idx := _get_state_index(state_name)
	if idx == -1:
		return null
	return _states[idx]
#endregion


#region Inner Classes
class Action:
	var toggle : bool
	var state : int
	var action_name : StringName
	
	func _init(act_name : StringName, toggle_val : bool) -> void:
		action_name = act_name
		toggle = toggle_val
		
		if toggle_val:
			state = ACTION_STATE.STARTED
			return
		state = ACTION_STATE.NONE
	
	func used() -> bool:
		return ACTION_STATE.NONE != (state & ACTION_STATE.HELD)
	func compair(comp : ACTION_STATE) -> bool:
		return comp == (state & ACTION_STATE.HELD)
#endregion
