@abstract
class_name StateModule extends Node


#region External Variables
@export var auto_call : bool = true
#endregion



#region Public Methods (State Change)
@abstract
func enter_state() -> void
@abstract
func exit_state() -> void
#endregion
