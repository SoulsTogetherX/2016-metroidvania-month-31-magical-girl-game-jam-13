@tool
extends ActionLeaf


#region Virtual Methods
func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.queue_free()
	return SUCCESS
#endregion
