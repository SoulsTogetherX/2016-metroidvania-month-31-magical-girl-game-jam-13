@tool
extends ConditionLeaf


#region External Variables
@export_range(0.0, 500.0, 0.001, "or_greater") var forgiveness : float = 100.0
#endregion


func tick(actor: Node, blackboard: Blackboard) -> int:
	var intreast : Vector2 = blackboard.get_value(
		GlobalLabels.bh_blackboard.GET_INTEREST_POINT
	).call()
	
	if absf(intreast.x - actor.global_position.x) <= forgiveness:
		return SUCCESS
	return FAILURE
