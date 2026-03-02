@tool
extends ActionLeaf


#region Public Methods (State Change)
func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return RUNNING
#endregion
