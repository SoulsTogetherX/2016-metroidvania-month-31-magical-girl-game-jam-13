extends HSMBranch


#region External Variables
@export_group("States")
@export var jump_state : HSMBranch
@export var wall_jump_state : HSMBranch
@export var ground_state : HSMBranch

@export_group("Other")
@export var wall_detect : Area2D
@export var ability_cache : AbilityCacheModule

@export_subgroup("Timers")
@export var coyote_timer : Timer
@export var coyote_wall_timer : Timer
@export var jump_buffer : Timer
#endregion



#region Virtual Methods
func _ready() -> void:
	if !coyote_timer:
		return
	coyote_timer.one_shot = true
#endregion


#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_JUMPING:
			var ctx := get_context()
			var max_wall_jumps := 3 if ability_cache.has_ability(
				AbilityData.ABILITY_TYPE.WALL_JUMP
			) else 0
			var double_jump : bool = ability_cache.has_ability(
				AbilityData.ABILITY_TYPE.DOUBLE_JUMP
			)
			
			var wall_jump_count : int = ctx.get_value(GlobalLabels.hsm_context.VAL_WALL_JUMP_COUNT)
			if (_is_touching_wall() &&
				wall_jump_count < max_wall_jumps
			):
				change_state(wall_jump_state)
				return
			
			var jump_count : int = ctx.get_value(GlobalLabels.hsm_context.VAL_JUMP_COUNT)
			if double_jump && jump_count <= 1:
				change_state(jump_state)
				return
			
			if (coyote_timer && !coyote_timer.is_stopped()):
				coyote_timer.stop()
				change_state(jump_state)
				return
			
			if jump_buffer:
				jump_buffer.start()
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_ON_WALL:
			var ctx := get_context()
			if ctx.is_action(
				GlobalLabels.hsm_context.ACT_IN_AIR
			):
				coyote_wall_timer.start()
		GlobalLabels.hsm_context.ACT_IN_AIR:
			if !jump_buffer.is_stopped():
				jump_buffer.stop()
				change_state(jump_state)

func _is_touching_wall() -> bool:
	var ctx := get_context()
	if ctx.is_action(
		GlobalLabels.hsm_context.ACT_ON_WALL
	):
		return true
	return !coyote_wall_timer.is_stopped()
#endregion


#region Public State Change Methods
func passthrough_state(_act : Node, ctx : HSMContext) -> HSMBranch:
	if ctx.is_action(
		GlobalLabels.hsm_context.ACT_IN_AIR
	):
		return null
	return ground_state
#endregion
