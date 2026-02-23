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
	if !action_cache.is_action(&"on_floor"):
		return stop_state
	if action_cache.get_value(&"hault_input"):
		return stop_state
	
	return null

func enter_state() -> void:
	action_cache.set_action(&"hault_input", true)
	punch_delay.timeout.connect(_end_punch)
	punch_delay.start()
func exit_state() -> void:
	punch_delay.timeout.disconnect(_end_punch)
	action_cache.set_action(&"hault_input", false)
#endregion
