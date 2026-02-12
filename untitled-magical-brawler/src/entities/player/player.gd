extends CharacterBody2D


#region External Variables
@export var player_input: PlayerInputComponent
@export var action_cache: ActionCacheComponent
@export var movement: MovementComponent
#endregion



#region Virtual Methods
func _physics_process(delta: float) -> void:
	movement.handle_gravity(delta)
	movement.apply_velocity(self)
	action_cache.progress_cache(
		player_input.horizontal_moving(),
		player_input.jumping(),
		is_on_floor(),
		is_on_ceiling(),
		is_on_wall(),
		player_input.attacking()
	)
#endregion
