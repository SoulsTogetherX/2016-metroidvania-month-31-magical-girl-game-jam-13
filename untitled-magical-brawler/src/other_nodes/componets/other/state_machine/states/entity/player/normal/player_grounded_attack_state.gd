extends StateActionNode


#region External Variables
@export_group("States")
@export var stop_state : StateNode

@export_group("Other")
@export var punch_delay : Timer
#endregion



#region Private Methods
func _end_punch() -> void:
	force_change(stop_state)
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	if action_cache.is_action(&"in_air"):
		return stop_state
	
	return null

func enter_state() -> void:
	action_cache.set_action(&"hault_input_checks", true)
	punch_delay.timeout.connect(_end_punch)
	punch_delay.start()
func exit_state() -> void:
	punch_delay.timeout.disconnect(_end_punch)
	action_cache.set_action(&"hault_input_checks", false)
	
	action_cache.force_action_signal.call_deferred(
		&"player_jump"
	)
#endregion
