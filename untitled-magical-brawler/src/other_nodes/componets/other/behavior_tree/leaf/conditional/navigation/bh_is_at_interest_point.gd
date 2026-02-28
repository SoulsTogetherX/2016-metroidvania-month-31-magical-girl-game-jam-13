@tool
extends ConditionLeaf


#region External Variables
@export_range(0, 100, 0.001, "or_greater") var forgiveness : float = 20.0
#endregion



#region Virtual Methods
func tick(actor: Node, blackboard: Blackboard) -> int:
	var act : BaseEntity = actor
	
	var point : Vector2 = blackboard.get_value(
		GlobalLabels.bh_blackboard.INTEREST_POINT,
		act.global_position
	)
	
	if absf(act.global_position.x - point.x) <= forgiveness:
		return SUCCESS
	return FAILURE
#endregion
