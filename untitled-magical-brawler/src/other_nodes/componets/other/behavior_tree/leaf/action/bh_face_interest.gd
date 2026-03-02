@tool
extends ActionLeaf


#region Public Methods (State Change)
func tick(actor: Node, blackboard: Blackboard) -> int:
	var entity : BaseEntity = actor
	var get_point : Callable = blackboard.get_value(
		GlobalLabels.bh_blackboard.GET_INTEREST_POINT,
	)
	var move_dir : float = signf(get_point.call().x - entity.global_position.x)
	
	if !is_zero_approx(move_dir):
		entity.change_direction(move_dir < 0, false)
	return SUCCESS
#endregion
