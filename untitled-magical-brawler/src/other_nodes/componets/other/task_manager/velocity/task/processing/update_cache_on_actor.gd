extends TaskNode


#region External Variables
@export_group("Modules")
@export var action_cache_c : ActionCacheComponent
@export var input_c : PlayerInputComponent

@export_group("Other")
@export var actor : CharacterBody2D
#endregion



#region Public Virtual Methods
func task_physics(_delta : float, args : Dictionary) -> bool:
	var act : CharacterBody2D = args.get(&"actor", actor)
	var act_cache : ActionCacheComponent = args.get(
		&"action_cache", action_cache_c
	)
	var input : PlayerInputComponent = args.get(
		&"input", input_c
	)
	
	act_cache.progress_cache(
		input.horizontal_moving(),
		input.jumping(),
		act.is_on_floor(),
		act.is_on_ceiling(),
		act.is_on_wall(),
		input.attacking()
	)
	
	return true
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	var act : CharacterBody2D = args.get(&"actor", actor)
	if act == null:
		return false
	
	var act_cache : ActionCacheComponent = args.get(
		&"action_cache", action_cache_c
	)
	if act_cache == null:
		return false
	
	var input : PlayerInputComponent = args.get(
		&"input", input_c
	)
	if input == null:
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Update_Cache_Task"
#endregion
