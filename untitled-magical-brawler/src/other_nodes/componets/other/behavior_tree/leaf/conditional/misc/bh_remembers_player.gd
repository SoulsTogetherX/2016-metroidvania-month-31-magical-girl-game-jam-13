@tool
extends ConditionLeaf


#region Virtual Methods
func tick(_actor: Node, blackboard: Blackboard) -> int:
	if blackboard.has_value(
		GlobalLabels.bh_blackboard.PLAYER
	):
		return SUCCESS
	return FAILURE
#endregion
