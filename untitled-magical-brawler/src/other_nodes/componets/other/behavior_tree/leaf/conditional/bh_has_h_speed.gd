@tool
extends ConditionLeaf


#region External Variables
@export_range(0.0, 500.0, 0.001, "or_greater") var forgiveness : float = 50.0
#endregion


#region Public Methods (State Change)
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var entitiy : BaseEntity = actor
	if absf(entitiy.get_entity_velocity().x) <= forgiveness:
		return FAILURE 
	return SUCCESS
#endregion
