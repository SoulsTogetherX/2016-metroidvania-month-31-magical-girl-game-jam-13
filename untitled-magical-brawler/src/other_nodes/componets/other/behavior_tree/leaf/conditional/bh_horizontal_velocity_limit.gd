@tool
extends ConditionLeaf


#region External Variables
@export_range(0.0, 10.0, 0.001, "or_greater") var speed_limit : float = 0.0:
	set(val):
		speed_limit = maxf(val, 0.0)
#endregion



#region Virtual Methods
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var act : Enemy = actor
	
	if absf(act.get_entity_velocity().x) <= speed_limit:
		return SUCCESS
	return FAILURE
#endregion
