@tool
extends ConditionLeaf


#region Virtual Methods
func tick(_actor: Node, blackboard: Blackboard) -> int:
	if blackboard.get_value(
		GlobalLabels.bh_blackboard.DETECTED_PLAYER
	):
		return SUCCESS
	return FAILURE
#endregion
