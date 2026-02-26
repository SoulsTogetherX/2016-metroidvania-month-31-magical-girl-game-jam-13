class_name AnimationLabels extends Object


#region Enum
enum ACTIONS {
	RESET,
	IDLE,
	MOVING,
	DEAD,
	STUN
}
#endregion


#region Constants
const _actions : Dictionary[ACTIONS, StringName] = {
	ACTIONS.RESET : "RESET",
	ACTIONS.IDLE : "IDLE",
	ACTIONS.MOVING : "MOVE",
	ACTIONS.DEAD : "DEAD",
	ACTIONS.STUN : "STUN"
}
#endregion


#region Static Methods
static func get_label(act : ACTIONS) -> StringName:
	return _actions.get(act, &"")
#endregion
