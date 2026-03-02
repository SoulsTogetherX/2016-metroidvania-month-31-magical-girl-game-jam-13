@tool
extends ActionLeaf


#region Public Methods
func tick(actor: Node, blackboard: Blackboard) -> int:
	var enemy : Enemy = actor
	enemy.update_patrol_point()
	
	blackboard.set_value(
		GlobalLabels.bh_blackboard.GET_INTEREST_POINT,
		enemy.get_patrol_point
	)
	
	return SUCCESS
#endregion
