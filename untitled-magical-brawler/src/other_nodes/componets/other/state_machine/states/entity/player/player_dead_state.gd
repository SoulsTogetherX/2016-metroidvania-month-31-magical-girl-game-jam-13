extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent
@export var animation_player : AnimationPlayer
@export var velocity_c : VelocityComponent
#endregion


#region External Variables
var _animation_check : bool = false
#endregion



#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	if action_cache_module.is_action_started(&"on_floor") && _animation_check:
		velocity_c.velocity = Vector2.ZERO
		animation_player.play(&"dead")
		_animation_check = false
	return null
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	_animation_check = true
#endregion
