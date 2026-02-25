@abstract
class_name TaskNode extends Node


#region Public Signals
@warning_ignore("unused_signal")
signal task_began
@warning_ignore("unused_signal")
signal task_finished
#endregion


#region Public Signals
signal _force_start(
	node : TaskNode, given_args : Dictionary, overwrite : bool
)
signal _force_stop(node : TaskNode)
signal _disable_task(node : TaskNode, toggle : bool)
signal _update_process(node : TaskNode)
#endregion


#region External Variables
@export_group("Settings")
@export var disabled : bool:
	set = set_disabled,
	get = get_disabled

@export_group("Proccessing")
@export var need_process : bool = false:
	set(val):
		if val == need_process:
			return
		need_process = val
		_update_process_mode()
@export var need_physics : bool = false:
	set(val):
		if val == need_physics:
			return
		need_physics = val
		_update_process_mode()
@export var need_input : bool = false:
	set(val):
		if val == need_input:
			return
		need_input = val
		_update_process_mode()
#endregion


#region External Variables
var args : Dictionary
#endregion


#region Private Variables
var _running : bool
var _disabled : bool

var _process_mode_queued : bool
#endregion


#region Private Methods
func _update_process_mode() -> void:
	_update_process.emit(self)
	_process_mode_queued = false
#endregion



#region Public Virtual Methods
func task_process(_delta : float) -> void:
	return
func task_physics(_delta : float) -> void:
	return
func task_input(_event: InputEvent) -> void:
	return
#endregion


#region Public Methods (Action States)
func task_passthrough() -> bool:
	return true
func task_begin() -> void:
	return
func task_end() -> void:
	pass
#endregion


#region Public Methods (Helper)
func force_start(given_args : Dictionary, overwrite : bool) -> void:
	_force_start.emit(self, given_args, overwrite)
func force_end() -> void:
	_force_stop.emit(self)

func set_disabled(val : bool) -> void:
	if val == _disabled:
		return
	_disabled = val
	_disable_task.emit(self, val)
func get_disabled() -> bool:
	return _disabled

func queue_process_update() -> void:
	if _process_mode_queued:
		return
	_process_mode_queued = true
	_update_process_mode.call_deferred()
#endregion


#region Public Methods (Accesser)
func is_running() -> bool:
	return _running
func is_disabled() -> bool:
	return _disabled
#endregion


#region Public Methods (Helper)
func get_task_manager() -> TaskManager:
	var manager : TaskManager = get_parent()
	if !manager:
		push_error("TaskNode isn't a child of a 'TaskManager' node.")
	
	return manager
#endregion
