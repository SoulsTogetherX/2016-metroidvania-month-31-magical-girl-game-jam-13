@abstract
class_name State extends Node

#region Signals
@warning_ignore("unused_signal")
signal force_change(state : State)
#endregion



#region Public Virtual Methods
func process_frame(_delta: float) -> State:
	return null
func process_physics(_delta: float) -> State:
	return null
func process_input(_input: InputEvent) -> State:
	return null
#endregion


#region Public Methods (State Change)
func state_passthrough() -> State:
	return null
func enter_state() -> void:
	pass
func exit_state() -> void:
	pass
#endregion
