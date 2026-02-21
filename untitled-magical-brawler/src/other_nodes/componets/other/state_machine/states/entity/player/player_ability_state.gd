extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent
@export var velocity_c : VelocityComponent

@export_group("States")
@export var end_state : StateNode

@export_group("Other")
@export var timer : Timer
#endregion



#region Private Methods
func _force_end_state() -> void:
	force_change(end_state)
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	if !action_cache_module.is_action(&"on_floor"):
		return end_state
	return null
func enter_state() -> void:
	velocity_c.set_velocity(Vector2.ZERO)
	timer.start()
	timer.timeout.connect(_force_end_state, CONNECT_ONE_SHOT)
#endregion
