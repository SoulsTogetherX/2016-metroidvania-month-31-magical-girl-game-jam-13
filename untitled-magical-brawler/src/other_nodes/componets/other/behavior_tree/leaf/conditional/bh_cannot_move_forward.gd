@tool
extends ConditionLeaf


#region External Variables
@export var raycast : RayCast2D
@export var wall_check : CollisionShape2D
#endregion


#region Public Methods (State Change)
func tick(_actor: Node, _blackboard: Blackboard) -> int:
	if wall_check && !Utilities.manual_collide_check(
		wall_check,
		true, false, Constants.COLLISION.GROUND
	).is_empty():
		return FAILURE
	
	if raycast:
		raycast.force_raycast_update()
		if !raycast.get_collider():
			return FAILURE
	return SUCCESS
#endregion
