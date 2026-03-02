@tool
extends ActionLeaf



#region Public Methods
func tick(_actor: Node, blackboard: Blackboard) -> int:
	blackboard.set_value(
		GlobalLabels.bh_blackboard.GET_INTEREST_POINT,
		func() -> Vector2: return Global.player.global_position
	)
	return SUCCESS
#endregion
