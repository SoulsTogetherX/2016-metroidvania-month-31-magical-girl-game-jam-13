@abstract
class_name StateNode extends Node

#region Signals
@warning_ignore("unused_signal")
signal force_change(state : StateNode)
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
