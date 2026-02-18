class_name AnimationStateMachine extends StateMachine


#region External Variables
@export var animation_player : AnimationPlayer
#endregion



#region Private Methods (Helper)
func _change_state(new_state: StateNode) -> void:
	if _current_state:
		_current_state.exit_state()
		if _current_state is AnimationStateNode:
			_current_state._end_animation(animation_player)
		
		_current_state._force_change.disconnect(_change_state)
		_current_state._running = false
	
	if !new_state:
		clear_state()
		return
	
	var check_state : StateNode = new_state
	while check_state:
		_current_state = check_state
		check_state = check_state.state_passthrough()
	
	_current_state._force_change.connect(_change_state, CONNECT_DEFERRED)
	_current_state._running = true
	if _current_state is AnimationStateNode:
		_current_state._start_animation(animation_player)
	_current_state.enter_state()
#endregion
