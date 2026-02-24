extends StateActionConditional


#region External Variables
@export_group("States")
@export var state : StateNode

@export_group("Actions")
@export var action : StringName

@export_group("Other")
@export var on_direct_check : bool = true
#endregion



#region Public Methods (State Change)
func conditional_check() -> StateNode:
	if on_direct_check && action_cache.is_action(action):
		return state
	return null
#endregion


#region Public Virtual Methods
func action_start(action_name : StringName) -> StateNode:
	if action_name == action:
		return state
	return null
#endregion
