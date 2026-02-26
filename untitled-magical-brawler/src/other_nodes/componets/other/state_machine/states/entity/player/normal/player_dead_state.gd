extends StateActionNode


#region External Variables
@export_group("Modules")
@export var animation_player : AnimationPlayer
@export var velocity_module : VelocityComponent

@export_group("States")
@export var stop_state : StateNode
#endregion


#region Private Variables
var _dead_mutex : bool
#endregion



#region Private Methods
func _on_dead_end() -> void:
	if _dead_mutex:
		return
	_dead_mutex = true
	
	velocity_module.velocity = Vector2.ZERO
	animation_player.play(&"dead")
#endregion


#region Public Virtual Methods
func action_finished(action_name : StringName) -> void:
	match action_name:
		&"in_air":
			_on_dead_end()
		&"dead":
			force_change(stop_state)
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	_dead_mutex = false
	action_cache.set_value(&"stable_state", true)
	
	if !action_cache.is_action(&"in_air"):
		_on_dead_end.call_deferred()
func exit_state() -> void:
	action_cache.set_value(&"stable_state", false)
#endregion
