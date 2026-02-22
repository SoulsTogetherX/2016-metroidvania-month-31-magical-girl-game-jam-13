extends StateActionNode


#region External Variables
@export_group("Modules")
@export var animation_player : AnimationPlayer
@export var velocity_module : VelocityComponent
@export var h_direction_module : HDirectionComponent
#endregion



#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"on_floor":
			velocity_module.velocity = Vector2.ZERO
			animation_player.play(&"dead")
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	h_direction_module.disable = true
func exit_state() -> void:
	h_direction_module.disable = false
#endregion
