extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent
@export var task : VelocityTaskManager
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	if action_cache_module.is_action(&"on_floor"):
		task.velocity_module.velocity = Vector2.ZERO
	return null
#endregion
	
