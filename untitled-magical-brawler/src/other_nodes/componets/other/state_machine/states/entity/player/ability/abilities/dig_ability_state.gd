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



#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"ability_use":
			if animation_player.is_playing():
				return
			if !ability_cache.can_end({&"collide": ground_collide}):
				return
			
			settup_exit_state()
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	ground_ray_cast.enabled = true
	enter_manual_modules()
func settup_exit_state() -> void:
	ground_ray_cast.enabled = false
	exit_manual_modules()
	
	await animation_player.animation_finished
	force_change(normal_state)
#endregion
