@tool
extends ActionLeaf


#region External Variables
@export var moving_point_task : TaskNode
#endregion



#region External Variables
func before_run(actor: Node, _blackboard: Blackboard) -> void:
	var act : Enemy = actor
	act.start_task(
		moving_point_task,
		{
			&"get_target_point": func() -> Vector2: return Global.player.global_position
		}
	)
func after_run(actor: Node, _blackboard: Blackboard) -> void:
	var act : Enemy = actor
	act.end_task(moving_point_task)

func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return RUNNING
#endregion
