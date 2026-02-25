extends StateActionNode


#region External Variables
@export_group("Modules")
@export var velocity_module : VelocityComponent

@export_group("States")
@export var move_state : StateNode
@export var stop_state : StateNode
#endregion



#region Private Methods
func _velocity_changed() -> void:
	if velocity_module.attempting_idle() && !action_cache.is_action(&"moving"):
		force_change(stop_state)
#endregion


#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"moving":
			force_change(move_state)
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	if action_cache.is_action(&"moving"):
		return move_state
	
	return null

func enter_state() -> void:
	velocity_module.hor_velocity_changed.connect(_velocity_changed)
func exit_state() -> void:
	velocity_module.hor_velocity_changed.disconnect(_velocity_changed)
#endregion
