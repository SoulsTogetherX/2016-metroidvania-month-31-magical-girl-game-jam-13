@tool
extends ActionLeaf


#region External Variables
@export var animation : GlobalLabels.animations.ACTIONS
#endregion



#region Virtual Methods
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var act : Enemy = actor
	act.play_animation(
		GlobalLabels.animations.get_label(animation)
	)
	return SUCCESS
#endregion
