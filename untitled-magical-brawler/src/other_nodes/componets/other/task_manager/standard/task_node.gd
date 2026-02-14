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
