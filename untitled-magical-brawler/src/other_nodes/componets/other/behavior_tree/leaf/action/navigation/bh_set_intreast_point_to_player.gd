@tool
extends ActionLeaf


#region Virtual Methods
func tick(_actor: Node, blackboard: Blackboard) -> int:
	var player : Player = blackboard.get_value(
		GlobalLabels.bh_blackboard.PLAYER
	)
	if player == null:
		return FAILURE
	
	blackboard.set_value(
		GlobalLabels.bh_blackboard.INTEREST_POINT,
		player.global_position
	)
	
	return SUCCESS
#endregion
