@tool
extends StateActionConditional


#region External Variables
@export_group("States")
@export var states : Array[StateNode]:
	set = set_states

@export_group("Actions")
@export var actions : Array[StringName]:
	set = set_actions

@export_group("Other")
@export var on_direct_check : bool = false
@export var on_start_check : bool = false
@export var on_finished_check : bool = false
#endregion



#region Public Methods (State Change)
func conditional_check() -> StateNode:
	if !on_direct_check:
		return null
	for idx : int in range(actions.size()):
		if action_cache.is_action(actions[idx]):
			return states[idx]
	return null
#endregion


#region Public Virtual Methods
func action_start(action_name : StringName) -> StateNode:
	if !on_start_check:
		return null
	for idx : int in range(actions.size()):
		if action_name == actions[idx]:
			return states[idx]
	return null
func action_finished(action_name : StringName) -> StateNode:
	if !on_finished_check:
		return null
	for idx : int in range(actions.size()):
		if action_name == actions[idx]:
			return states[idx]
	return null
#endregion


#region Public Setter Methods
func set_states(val : Array[StateNode]) -> void:
	actions.resize(val.size())
	states = val
func set_actions(val : Array[StringName]) -> void:
	val.resize(states.size())
	actions = val
#endregion
