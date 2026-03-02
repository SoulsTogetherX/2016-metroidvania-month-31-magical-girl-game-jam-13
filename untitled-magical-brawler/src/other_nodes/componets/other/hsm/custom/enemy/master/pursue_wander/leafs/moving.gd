extends HSMBranch


#region External Variables
@export var move_to_task : TaskNode
#endregion


#region Public State Change Methods
func enter_state(act : Node, _ctx : HSMContext) -> void:
	var enemy : Enemy = act
	enemy.start_task(
		move_to_task,
		{ &"get_target_point" : enemy.get_target_point }
	)
func exit_state(act : Node, _ctx : HSMContext) -> void:
	var enemy : Enemy = act
	enemy.end_task(move_to_task)
#endregion
