class_name AnimationLabels extends Object


#region Enum
# Common
enum ACTIONS {
	RESET,
	FALL,
	IDLE,
	RUNNING,
	JUMP,
	ATTACK,
	DEAD,
	STUN
}
#endregion


#region Constants
# Common
const _actions : Dictionary[ACTIONS, StringName] = {
	ACTIONS.RESET : &"RESET",
	ACTIONS.FALL : &"FALL",
	ACTIONS.IDLE : &"IDLE",
	ACTIONS.RUNNING : &"RUNNING",
	ACTIONS.JUMP : &"JUMP",
	ACTIONS.ATTACK : &"ATTACK",
	ACTIONS.DEAD : &"DEAD",
	ACTIONS.STUN : &"STUN"
}

# Uncommon
const DIG_START := &"DIG_START"
const DIG_END := &"DIG_END"
#endregion


#region Static Methods
static func get_label(act : ACTIONS) -> StringName:
	return _actions.get(act, &"")
#endregion
