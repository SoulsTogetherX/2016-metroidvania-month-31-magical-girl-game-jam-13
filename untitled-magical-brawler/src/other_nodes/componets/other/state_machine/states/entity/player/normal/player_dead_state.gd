extends StateActionNode


#region External Variables
@export_group("Modules")
@export var animation_player : AnimationPlayer
@export var velocity_module : VelocityComponent
#endregion



#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	match action_name:
		&"in_air":
			velocity_module.velocity = Vector2.ZERO
			animation_player.play(&"dead")
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	action_cache.set_value(&"stable_state", true)
func exit_state() -> void:
	action_cache.set_value(&"stable_state", false)
#endregion
