extends StateActionNode


#region External Variables
@export_group("Modules")
@export var ability_cache : AbilityCacheModule

@export_group("States")
@export var normal_state : StateNode

@export_group("Collsion")
@export var ground_ray_cast : RayCast2D
@export var ground_collide : CollisionShape2D

@export_group("Other")
@export var animation_player: AnimationPlayer
#endregion



#region Private Methods
func _force_exit_state(_animation : StringName) -> void:
	force_change(normal_state)
#endregion


#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"ability_use":
			if animation_player.is_playing():
				return
			if !ability_cache.can_end(
				{&"collide": ground_collide}
			):
				return
			
			ground_ray_cast.enabled = false
			exit_manual_modules()
			animation_player.animation_finished.connect(
				_force_exit_state
			)
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	var ability := ability_cache.get_current_ability()
	if !ability || !ability.can_start(
		{
			&"collide": ground_collide,
			&"on_ground": !action_cache.is_action(&"in_air")
		}
	):
		return normal_state
	
	return null
func enter_state() -> void:
	ground_ray_cast.enabled = true
	enter_manual_modules()
func exit_state() -> void:
	animation_player.animation_finished.disconnect(
		_force_exit_state
	)
#endregion
