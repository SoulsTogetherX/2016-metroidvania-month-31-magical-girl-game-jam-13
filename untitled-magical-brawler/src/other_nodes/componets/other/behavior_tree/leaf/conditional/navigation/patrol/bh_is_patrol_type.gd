@tool
extends ConditionLeaf


#region External Variables
@export var patrol_type : Enemy.PATROL_TYPE
#endregion



#region Virtual Methods
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var act : Enemy = actor
	
	if patrol_type == act.patrol_type:
		return SUCCESS
	return FAILURE
#endregion
