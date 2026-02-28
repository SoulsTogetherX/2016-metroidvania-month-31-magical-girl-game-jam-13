class_name HSMContext extends Node


#region Signals
signal action_started(action_name : StringName)
signal action_finished(action_name : StringName)

signal value_changed(value_name : StringName)
#endregion


#region Enum
enum ACTION_STATE {
	NONE     = 0b00,
	STARTED  = 0b01,
	FINISHED = 0b10,
	HELD     = 0b11,
}

enum UPDATE_CALLBACK {
	MANUAL     = 0b00,
	PROCESS  = 0b01,
	PHYSICS = 0b10
}
#endregion


#region Private Variables
var _actions : Array[Action]
var _actions_cache : Dictionary[StringName, int]

var _values : Array[Value]
var _values_cache : Dictionary[StringName, int]
#endregion


#region External Variables
@export var starting_value : Dictionary
#endregion



#region Virtual Methods
func _ready() -> void:
	for value_name : StringName in starting_value:
		set_value(value_name, starting_value[value_name])
#endregion


#region Private Methods (Helper)
func _get_action_index(action_name : StringName) -> int:
	return _actions_cache.get(action_name, -1)
func _get_value_index(value_name : StringName) -> int:
	return _values_cache.get(value_name, -1)

func _force_action_signal(act : Action) -> void:
	if act.toggle:
		action_started.emit(act.action_name)
		return
	action_finished .emit(act.action_name)
#endregion


#region Public Methods (Action Cache)
func set_action(action_name : StringName, toggle : bool) -> void:
	var idx := _get_action_index(action_name)
	if idx == -1:
		var act := Action.new(
			action_started,
			action_finished,
			action_name,
			toggle
		)
		
		_actions_cache[action_name] = _actions.size()
		_actions.push_back(act)
		return
	
	_actions.get(idx).toggle = toggle

func set_value(value_name : StringName, val : Variant) -> void:
	var idx := _get_value_index(value_name)
	if idx == -1:
		_values_cache[value_name] = _values.size()
		_values.push_back(Value.new(value_name, val))
		
		value_changed.emit(value_name)
		return
	
	if _values[idx].value != val:
		_values[idx].value = val
		value_changed.emit(value_name)
#endregion


#region Public Methods (Erase)
func clear_caches() -> void:
	_actions.clear()
	_actions_cache.clear()
	
	_values.clear()
	_values_cache.clear()

func erase_action(action_name : StringName) -> void:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return
	
	_actions[idx] = _actions.back()
	_actions.pop_back()
	_actions_cache[_actions[idx].action_name] = idx
func erase_value(value_name : StringName) -> void:
	var idx := _get_value_index(value_name)
	if idx == -1:
		return
	
	_values[idx] = _values.back()
	_values.pop_back()
	_values_cache[_values[idx].value_name] = idx
#endregion


#region Public Methods (Action Checks)
func is_action(action_name : StringName, default : bool = false) -> bool:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return default
	return _actions[idx].toggle

func get_value(value_name : StringName, default : Variant = null) -> Variant:
	var idx := _get_value_index(value_name)
	if idx == -1:
		return default
	return _values[idx].value

func force_action_signal(action_name : StringName) -> void:
	var idx := _get_action_index(action_name)
	if idx == -1:
		return
	
	_force_action_signal(_actions[idx])
func force_all_action_signals() -> void:
	for act : Action in _actions:
		_force_action_signal(act)
#endregion


#region Inner Classes
class Action:
	var action_started : Signal
	var action_finished : Signal
	
	var action_name : StringName
	var toggle : bool:
		set = set_toggle
	
	func _init(
		act_s : Signal, fin_s : Signal,
		act_name : StringName, tog : bool
	) -> void:
		action_started = act_s
		action_finished = fin_s
		action_name = act_name
		toggle = tog
	
	func set_toggle(val : bool) -> void:
		if val == toggle:
			return
		toggle = val
		
		if toggle:
			action_started.emit(action_name)
			return
		action_finished.emit(action_name)

class Value:
	var value_name : StringName
	var value : Variant
	
	func _init(
		val_name : StringName, val : Variant
	) -> void:
		value_name = val_name
		value = val
#endregion
