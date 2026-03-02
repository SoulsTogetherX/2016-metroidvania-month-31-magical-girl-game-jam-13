@tool
extends ConditionLeaf


#region External Variables
@export var detector : CollisionShape2D
@export_flags_2d_physics var mask : int = 4
#endregion



#region Public Methods (State Change)
func tick(_actor: Node, _blackboard: Blackboard) -> int:
	var results := Utilities.manual_collide_check(
		detector,
		true,
		false,
		Constants.COLLISION.PLAYER
	)
	if results.is_empty():
		return FAILURE
	return SUCCESS
#endregion
