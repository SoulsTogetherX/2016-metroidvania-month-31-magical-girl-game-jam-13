extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent

@export_group("States")
@export var stop_state : StateNode
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	if !action_cache_module.is_action(&"jumping"):
		return stop_state
	if action_cache_module.is_action_started(&"on_floor"):
		return stop_state
	return null
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	action_cache_module.set_state(&"has_jumped", true)
#endregion
