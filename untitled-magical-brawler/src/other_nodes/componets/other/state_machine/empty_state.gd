@abstract
class_name EmptyState extends Node

#region Signals
@warning_ignore("unused_signal")
signal force_change(state : EmptyState)
#endregion



#region Virtual Methods
@abstract
func process_frame(delta: float) -> EmptyState
@abstract
func process_physics(delta: float) -> EmptyState
@abstract
func process_input(input: InputEvent) -> EmptyState
#endregion


#region Public Methods (Identifier)
@abstract
func state_name() -> StringName
#endregion


#region Public Methods (State Change)
@abstract
func state_passthrough(actor : Node) -> EmptyState
@abstract
func enter_state(actor : Node) -> void
@abstract
func exit_state() -> void
#endregion
