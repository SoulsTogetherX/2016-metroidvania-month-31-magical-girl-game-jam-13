extends HSMBranch


#region External Variables
@export_group("States")
@export var jump_state : HSMBranch
@export var wall_jump_state : HSMBranch
@export var ground_state : HSMBranch

@export_group("Other")
@export var wall_detect : Area2D
@export var coyote_timer : Timer
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
			var max_wall_jumps := 3
			var max_jumps := 2
			
			var wall_jump_count : int = ctx.get_value(GlobalLabels.hsm_context.VAL_WALL_JUMP_COUNT)
			if (!wall_detect.get_overlapping_bodies().is_empty() &&
				ctx.is_action(GlobalLabels.hsm_context.ACT_MOVING) &&
				wall_jump_count < max_wall_jumps
			):
				change_state(wall_jump_state)
				return
			
			var jump_count : int = ctx.get_value(GlobalLabels.hsm_context.VAL_JUMP_COUNT)
			if jump_count <= max_jumps:
				if jump_count < max_jumps:
					change_state(jump_state)
					return
				if (coyote_timer && !coyote_timer.is_stopped()):
					change_state(jump_state)
					return
			
			if jump_buffer:
				jump_buffer.start()
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_IN_AIR:
			var ctx := get_context()
			ctx.set_value(GlobalLabels.hsm_context.VAL_JUMP_COUNT, 0)
			
			if jump_buffer && !jump_buffer.is_stopped():
				change_state(jump_state)
				return
			change_state(ground_state)
#endregion
