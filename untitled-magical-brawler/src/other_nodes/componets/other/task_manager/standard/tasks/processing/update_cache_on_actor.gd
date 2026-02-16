extends TaskNode


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent
@export var input_module : PlayerInputComponent

@export_group("Other")
@export var actor : CharacterBody2D
#endregion



#region Public Virtual Methods
func task_physics(_delta : float, args : Dictionary) -> bool:
	var act : Node2D = get_argument(args, &"actor", actor)
	var cache : ActionCacheComponent = get_argument(
		args, &"action_cache", action_cache_module
	)
	var player_input : PlayerInputComponent = get_argument(
		args, &"player_input", input_module
	)
	
	cache.progress_cache(
		player_input.horizontal_moving(),
		player_input.jumping(),
		act.is_on_floor(),
		act.is_on_ceiling(),
		act.is_on_wall(),
		player_input.attacking()
	)
	
	return true
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if !(get_argument(args, &"actor", actor) is Node2D):
		return false
	if !(get_argument(args, &"action_cache", action_cache_module) is ActionCacheComponent):
		return false
	if !(get_argument(args, &"player_input", input_module) is PlayerInputComponent):
		return false
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Update_Cache_Task"
#endregion
