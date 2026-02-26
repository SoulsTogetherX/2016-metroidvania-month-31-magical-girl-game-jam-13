@tool
extends ActionLeaf


#region External Variables
@export var task : TaskNode
#endregion



#region Virtual Methods
func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return RUNNING

func before_run(actor: Node, blackboard: Blackboard) -> void:
	var act : Enemy = actor
	act.start_task(task,
		{ &"get_target_point" : blackboard.get_value.bind(
			GlobalLabels.bh_blackboard.INTEREST_POINT
		) }
	)
func interrupt(actor: Node, _blackboard: Blackboard) -> void:
	var act : Enemy = actor
	act.end_task(task)
#endregion
