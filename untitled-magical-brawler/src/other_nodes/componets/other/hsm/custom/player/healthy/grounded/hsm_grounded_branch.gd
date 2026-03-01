extends HSMBranch


#region External Variables
@export_group("States")
@export var normal_state : HSMBranch
@export var fall_state : HSMBranch
@export var attack_state : HSMBranch
@export var dig_state : HSMBranch

@export_group("Other")
@export var ground_collider : CollisionShape2D
@export var ability_cache : AbilityCacheModule
#endregion



#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_IN_AIR:
			change_state(fall_state)
		GlobalLabels.hsm_context.ACT_ATTACKING:
			change_state(attack_state)
		GlobalLabels.hsm_context.ACT_PLAYER_DIG:
			var ctx := get_context()
			
			if ability_cache.can_start(
				AbilityData.ABILITY_TYPE.DIG,
				{
					&"collide" : ground_collider,
					&"on_ground" : !ctx.is_action(GlobalLabels.hsm_context.ACT_IN_AIR)
				}
			):
				change_state(dig_state)
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, _ctx : HSMContext) -> HSMBranch:
	return normal_state
func enter_state(act : Node, ctx : HSMContext) -> void:
	var player : Player = act
	player.update_camera_lead_y()
	
	ctx.set_value(GlobalLabels.hsm_context.VAL_JUMP_COUNT, 0)
	ctx.set_value(GlobalLabels.hsm_context.VAL_WALL_JUMP_COUNT, 0)
#endregion
