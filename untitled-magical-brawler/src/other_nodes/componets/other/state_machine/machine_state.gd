@abstract
class_name MachineState extends Node

#region Signals
@warning_ignore("unused_signal")
signal force_change(state : MachineState)
#endregion



#region Public Virtual Methods
func process_frame(_delta: float) -> MachineState:
	return null
func process_physics(_delta: float) -> MachineState:
	return null
func process_input(_input: InputEvent) -> MachineState:
	return null
#endregion


#region Public Methods (State Change)
func state_passthrough() -> MachineState:
	return null
func enter_state() -> void:
	pass
func exit_state() -> void:
	pass
#endregion
