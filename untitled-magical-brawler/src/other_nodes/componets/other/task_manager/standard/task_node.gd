@abstract
class_name TaskNode extends Node


#region Signals
@warning_ignore("unused_signal")
signal force_stop
#endregion


#region External Variables
@export var auto_start : bool
@export var auto_start_args : Dictionary
#endregion



#region Public Virtual Methods
func task_process(_delta : float, _args : Dictionary) -> bool:
	return true
func task_physics(_delta : float, _args : Dictionary) -> bool:
	return true
#endregion


#region Public Methods (Action States)
func task_begin(_args : Dictionary) -> bool:
	return true
func task_end(_args : Dictionary) -> void:
	pass
#endregion


#region Public Methods (Identifier)
@abstract
func task_id() -> StringName
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
	if !val:
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
#endregion
