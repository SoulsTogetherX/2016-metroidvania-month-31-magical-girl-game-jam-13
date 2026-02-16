class_name ForceState extends Node


#region External Variables
@export_group("Settings")
@export var state_machine : StateMachine
@export var state : StateNode
#endregion



#region Public Methods
func force_state() -> void:
	state_machine.force_state(state)
#endregion
