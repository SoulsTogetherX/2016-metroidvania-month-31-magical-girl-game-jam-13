extends StateActionNode


#region External Variables
@export_group("States")
@export var stop_state : StateNode
#endregion



#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"on_floor":
			force_change(stop_state)
func action_finished(action_name : StringName) -> void:
	match action_name:
		&"player_up":
			force_change(stop_state)
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	action_cache.set_value(&"has_jumped", true)
#endregion
