@tool
extends ActionLeaf


#region External Variables
@export var speed : float = 0.0
#endregion



#region Virtual Methods
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var act : Enemy = actor
	act.get_velocity_component().velocity.x = speed
	
	return SUCCESS
#endregion
