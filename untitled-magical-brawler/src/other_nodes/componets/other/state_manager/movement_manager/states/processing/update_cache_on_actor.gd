extends ManagedTaskState


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var input : PlayerInputComponent

@export_group("Other")
@export var actor : CharacterBody2D
#endregion



#region Public Virtual Methods
func state_physics(_delta : float, _args : Dictionary) -> bool:
	action_cache.progress_cache(
		input.horizontal_moving(),
		input.jumping(),
		actor.is_on_floor(),
		actor.is_on_ceiling(),
		actor.is_on_wall(),
		input.attacking()
	)
	
	return true
#endregion
	

#region Public Methods (Action States)
func begin_state(_args : Dictionary) -> bool:
	return actor != null && action_cache != null
#endregion


#region Public Methods (Identifier)
func state_id() -> StringName:
	return &"Update_Cache_Task"
#endregion
