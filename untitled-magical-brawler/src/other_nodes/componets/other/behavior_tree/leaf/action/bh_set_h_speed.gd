@tool
extends ActionLeaf


#region External Variables
@export var speed : float = 0.0
#endregion



#region Public Methods (State Change)
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var entity : BaseEntity = actor
	entity.get_velocity_component().velocity.x = speed
	return SUCCESS
#endregion
