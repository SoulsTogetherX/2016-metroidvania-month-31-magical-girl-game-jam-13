@tool
extends ActionLeaf




#region Virtual Methods
func tick(_actor: Node, blackboard: Blackboard) -> int:
	blackboard.erase_value(
		GlobalLabels.bh_blackboard.PLAYER
	)
	return SUCCESS
#endregion
