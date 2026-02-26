extends StateActionNode


#region External Variables
@export_group("States")
@export var stop_state : StateNode
#endregion



#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	if action_name == &"hit_stun":
		force_change(stop_state)
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	action_cache.set_value(&"stable_state", true)
func exit_state() -> void:
	action_cache.set_value(&"stable_state", false)
#endregion
