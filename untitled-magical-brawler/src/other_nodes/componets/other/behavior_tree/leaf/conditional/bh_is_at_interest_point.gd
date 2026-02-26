@tool
extends ConditionLeaf


#region External Variables
@export var forgiveness : float = 20.0
#endregion



#region Virtual Methods
func tick(actor: Node, blackboard: Blackboard) -> int:
	var act : Enemy = actor
	
	var point : Vector2 = blackboard.get_value(
		GlobalLabels.bh_blackboard.INTEREST_POINT
	)
	if absf(act.global_position.x - point.x) <= forgiveness:
		return SUCCESS
	return FAILURE
#endregion
