@tool
extends ActionLeaf



#region Public Methods (State Change)
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var entity : BaseEntity = actor
	if entity.is_animation_playing():
		return RUNNING
	return SUCCESS
#endregion
