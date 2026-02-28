extends HSMBranch


#region External Variables
@export_group("Modules")
@export var ability_cache : AbilityCacheModule

@export_group("States")
@export var normal_state : HSMBranch

@export_group("Task")
@export var dig_move_task : TaskNode

@export_group("Collsion")
@export var ground_collider : CollisionShape2D
@export var ground_ray_cast : RayCast2D
#endregion



#region Private Methods
func _dig_start() -> void:
	var entity : BaseEntity = get_actor()
	
	entity.start_task(
		dig_move_task, {
			&"move_dir" : get_context().get_value.bind(
				GlobalLabels.hsm_context.VAL_H_DIR
			),
			&"stop_raycast" : ground_ray_cast
		}
	)
	entity.get_animation_player().animation_finished.disconnect(
		_dig_start
	)
func _force_exit_state(_animation : StringName) -> void:
	var entity : BaseEntity = get_actor()
	
	change_state(normal_state)
	entity.get_animation_player().animation_finished.disconnect(
		_force_exit_state
	)
#endregion


#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	var act : BaseEntity = get_actor()
	
	match action_name:
		GlobalLabels.hsm_context.ACT_PLAYER_DIG:
			if act.is_animation_playing():
				return
			if !ability_cache.can_end(
				AbilityData.ABILITY_TYPE.DIG,
				{
					&"collide" : ground_collider
				}
			):
				return
			
			_on_exit(act)
#endregion


#region Public Methods (State Change)
func enter_state(act : Node, _ctx : HSMContext) -> void:
	var entity : BaseEntity = act
	ground_ray_cast.enabled = true
	
	entity.play_animation(GlobalLabels.animations.DIG_START)
	entity.get_velocity_component().velocity.x = 0.0
	entity.get_animation_player().animation_finished.connect(
		_dig_start.unbind(1)
	)
func exit_state(act : Node, _ctx : HSMContext) -> void:
	var entity : BaseEntity = act
	var player := entity.get_animation_player()
	
	if player.animation_finished.is_connected(_dig_start):
		player.animation_finished.disconnect(
			_dig_start
		)
	if player.animation_finished.is_connected(_force_exit_state):
		player.animation_finished.disconnect(
			_force_exit_state
		)
#endregion


#region Public Methods (State Change)
func _on_exit(act : BaseEntity) -> void:
	var entity : BaseEntity = act
	ground_ray_cast.enabled = false
	
	entity.end_task(dig_move_task)
	entity.play_animation(GlobalLabels.animations.DIG_END)
	entity.get_velocity_component().velocity.x = 0.0
	entity.get_animation_player().animation_finished.connect(
		_force_exit_state
	)
#endregion
