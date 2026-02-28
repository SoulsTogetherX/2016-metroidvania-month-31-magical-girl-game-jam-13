@tool
extends ActionLeaf


#region Virtual Methods
func tick(actor: Node, blackboard: Blackboard) -> int:
	var act : Enemy = actor
	var obj := act.get_patrol_obj()
	var interest : Vector2
	
	if obj == null:
		return FAILURE
	
	match act.patrol_type:
		Enemy.PATROL_TYPE.STATIONARY:
			interest = obj.global_position
		Enemy.PATROL_TYPE.WANDER:
			interest = Vector2.ZERO
		Enemy.PATROL_TYPE.PATH:
			interest = Vector2.ZERO
	
	blackboard.set_value(
		interest,
		GlobalLabels.bh_blackboard.INTEREST_POINT
	)
	return SUCCESS
#endregion
