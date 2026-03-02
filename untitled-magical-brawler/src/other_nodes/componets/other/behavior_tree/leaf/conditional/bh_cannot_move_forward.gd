@tool
extends ConditionLeaf


#region External Variables
@export var raycast : RayCast2D
#endregion


#region Public Methods (State Change)
func tick(_actor: Node, _blackboard: Blackboard) -> int:
	raycast.force_raycast_update()
	if !raycast.get_collider():
		return FAILURE
	return SUCCESS
#endregion
