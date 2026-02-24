@abstract
class_name StateNode extends Node


#region Private Signals
@warning_ignore("unused_signal")
signal _force_change(state : StateNode)
#endregion


#region External Variables
@export_group("Proccessing")
@export var need_process : bool = false
@export var need_physics : bool = false
@export var need_input : bool = false
#endregion


#region Private Variables
var _running : bool

var _modules : Array[StateModule]
var _conditionals : Array[StateConditional]
#endregion



#region Virtual Methods
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			_register_subnodes()
#endregion


#region Public Virtual Methods
func process_frame(_delta: float) -> StateNode:
	return null
func process_physics(_delta: float) -> StateNode:
	return null
func process_input(_input: InputEvent) -> StateNode:
	return null
#endregion


#region Private Methods (Helper)
func _enter_state() -> void:
	for module : StateModule in _modules:
		if module.auto_call:
			module.enter_state()
	enter_state()
func _exit_state() -> void:
	exit_state()
	for module : StateModule in _modules:
		if module.auto_call:
			module.exit_state()
func _state_passthrough() -> StateNode:
	var state : StateNode
	for con : StateConditional in _conditionals:
		if con.auto_call:
			state = con.conditional_check()
			if state != null:
				return state
	
	return state_passthrough()
func _disable_state(toggle : bool) -> void:
	_running = toggle
	disable_state(toggle)

func _register_subnodes() -> void:
	_modules.clear()
	_conditionals.clear()
	for child : Node in get_children():
		if child is StateModule:
			_modules.push_back(child)
		elif child is StateConditional:
			_conditionals.push_back(child)
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	return null
func enter_state() -> void:
	pass
func exit_state() -> void:
	pass

func disable_state(_toggle : bool) -> void:
	pass
#endregion


#region Public Methods (Force State)
func force_change(state : StateNode) -> void:
	_force_change.emit(state)
#endregion


#region Public Methods (Accesser)
func is_running() -> bool:
	return _running

func get_all_modules() -> Array[StateModule]:
	return _modules
func enter_manual_modules() -> void:
	for module : StateModule in _modules:
		if !module.auto_call:
			module.enter_state()
func exit_manual_modules() -> void:
	for module : StateModule in _modules:
		if !module.auto_call:
			module.exit_state()

func get_all_conditionals() -> Array[StateConditional]:
	return _conditionals
func check_manual_conditionals() -> StateNode:
	var state : StateNode
	for con : StateConditional in _conditionals:
		if !con.auto_call:
			state = con.conditional_check()
			if state != null:
				return state
	
	return null
#endregion
