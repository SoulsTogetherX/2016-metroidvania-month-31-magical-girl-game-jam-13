@abstract
class_name StateNode extends Node


#region Private Signals
@warning_ignore("unused_signal")
signal _force_change(state : StateNode)
#endregion


#region Private Variables
var _running : bool
#endregion



#region Public Virtual Methods
func process_frame(_delta: float) -> StateNode:
	return null
func process_physics(_delta: float) -> StateNode:
	return null
func process_input(_input: InputEvent) -> StateNode:
	return null
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	return null
func enter_state() -> void:
	pass
func exit_state() -> void:
	pass
#endregion


#region Public Methods (Force State)
func force_change(state : StateNode) -> void:
	_force_change.emit(state)
#endregion


#region Public Methods (Accesser)
func is_running() -> bool:
	return _running
#endregion
