@tool
extends ActionLeaf


#region Virtual Methods
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var act : Enemy = actor
	
	if act.is_animation_playing():
		return RUNNING
	return SUCCESS
#endregion
