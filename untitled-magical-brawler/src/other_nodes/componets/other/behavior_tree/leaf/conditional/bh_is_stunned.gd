@tool
extends ConditionLeaf


#region Virtual Methods
func tick(actor: Node, _blackboard: Blackboard) -> int:
	var act : Enemy = actor
	
	if act.has_status_effect(StatusEffect.STATUS_TYPE.STUN):
		return SUCCESS
	return FAILURE
#endregion
