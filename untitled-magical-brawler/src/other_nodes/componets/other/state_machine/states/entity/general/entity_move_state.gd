extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent

@export_group("States")
@export var jump_state : StateNode
@export var ability_state : StateNode
@export var fall_state : StateNode
@export var stop_state : StateNode
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	return _check_state()
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	return _check_state()
#endregion


#region Private Methods (Helper)
func _check_state() -> StateNode:
	if action_cache_module.is_action_started(&"player_up"):
		return jump_state
	if !action_cache_module.is_action(&"on_floor"):
		return fall_state
	if action_cache_module.is_action_started(&"player_ability"):
		return ability_state
	if !action_cache_module.is_action(&"moving"):
		return stop_state
	return null
#endregion
