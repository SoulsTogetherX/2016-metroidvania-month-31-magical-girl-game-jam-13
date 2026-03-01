extends HSMBranch


#region Constants
const PATROL_TYPE := Enemy.PATROL_TYPE
#endregion


#region External Variables
@export_group("States")
@export var stationary_state : HSMBranch

@export_group("Tasks")
@export var moving_point_task : TaskNode
#endregion



#region Public State Change Methods
func passthrough_state(act : Node, ctx : HSMContext) -> HSMBranch:
	var enemy : Enemy = act
	if enemy.patrol_type == PATROL_TYPE.NONE:
		ctx.set_action(
			GlobalLabels.hsm_context.ACT_MOVING, false
		)
		return stationary_state
	return null

func enter_state(act : Node, _ctx : HSMContext) -> void:
	var enemy : Enemy = act
	enemy.update_patrol_point()
	
	enemy.get_target_point = enemy.get_patrol_point
	enemy.start_task(
		moving_point_task,
		{ &"get_target_point" : enemy.get_target_point }
	)
func exit_state(act : Node, _ctx : HSMContext) -> void:
	var enemy : Enemy = act
	enemy.end_task(moving_point_task)
#endregion
