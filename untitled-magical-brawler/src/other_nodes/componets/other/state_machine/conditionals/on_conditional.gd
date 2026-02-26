extends StateActionConditional


#region External Variables
@export_group("States")
@export var state : StateNode

@export_group("Actions")
@export var action : StringName

@export_group("Other")
@export var on_direct_check : bool = false
@export var on_start_check : bool = false
@export var on_finished_check : bool = false
#endregion



#region Public Methods (State Change)
func conditional_check() -> StateNode:
	if on_direct_check && action_cache.is_action(action):
		return state
	return null
#endregion


#region Public Virtual Methods
func action_start(action_name : StringName) -> StateNode:
	if on_start_check && action_name == action:
		return state
	return null
func action_finished(action_name : StringName) -> StateNode:
	if on_finished_check && action_name == action:
		return state
	return null
#endregion
