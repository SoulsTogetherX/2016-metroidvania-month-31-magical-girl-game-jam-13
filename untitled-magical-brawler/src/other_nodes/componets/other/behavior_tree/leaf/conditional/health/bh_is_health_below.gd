@tool
extends ConditionLeaf


#region External Variables
@export_range(0, 10, 1, "or_greater") var health : int = 0:
	set(val):
		health = maxi(val, 0)
#endregion



#region Virtual Methods
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var act : CombatEntity = actor
	
	if act.get_health() <= health:
		return SUCCESS
	return FAILURE
#endregion
