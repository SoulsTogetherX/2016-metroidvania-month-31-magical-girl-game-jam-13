@abstract
class_name TaskNode extends Node


#region Public Signals
@warning_ignore("unused_signal")
signal task_began
@warning_ignore("unused_signal")
signal task_finished
#endregion


#region Private Signals
signal _force_start(
	id : StringName, given_args : Dictionary, overwrite : bool
)
signal _force_end
#endregion


#region External Variables
@export var disabled : bool
@export var auto_start : bool
@export var auto_start_args : Dictionary
#endregion


#region Private Variables
var _running : bool
#endregion



#region Public Virtual Methods
func task_process(_delta : float) -> bool:
	return true
func task_physics(_delta : float) -> bool:
	return true
#endregion


#region Public Methods (Action States)
func task_passthrough(_args : Dictionary) -> bool:
	return true
func task_begin() -> void:
	return
func task_end() -> void:
	pass
#endregion


#region Public Methods (Accesser)
func is_running() -> bool:
	return _running
func is_disabled() -> bool:
	return disabled
#endregion


#region Public Methods (Identifier)
@abstract
func task_id() -> StringName
#endregion


#region Public Methods (Force State)
func force_start_task(
	given_args : Dictionary = {}, overwrite : bool = false
) -> void:
	_force_start.emit(task_id(), given_args, overwrite)
func force_end_task() -> void:
	_force_end.emit()
#endregion


#region Public Methods (Helper)
func get_argument(
	args : Dictionary,
	arg : StringName,
	default : Variant = null
) -> Variant:
	var val : Variant = args.get(arg, default)
	if val is Callable:
		if !val.is_valid():
			push_error("No '%s' found" % arg)
			return null
		return val.call()
	if val == null:
		push_error("No '%s' found" % arg)
	return val
func get_callable(
	args : Dictionary,
	arg : StringName,
	call_args : Array[Variant] = []
) -> Variant:
	var val : Variant = args.get(arg, Callable())
	if !(val is Callable):
		push_error("No '%s' found" % arg)
		return null
	if !val.is_valid():
		push_error("No '%s' found" % arg)
		return null
	return val.callv(call_args)

func get_task_manager() -> TaskManager:
	var manager : TaskManager = get_parent()
	if !manager:
		push_error("TaskNode isn't a child of a 'TaskManager' node.")
	
	return manager
#endregion
