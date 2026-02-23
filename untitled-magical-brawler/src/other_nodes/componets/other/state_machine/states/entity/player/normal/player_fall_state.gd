extends StateActionNode


#region External Variables
@export_group("States")
@export var jump_state : StateNode
@export var land_state : StateNode

@export_group("Other")
@export var coyote_timer : Timer
@export var jump_buffer : Timer
#endregion



#region Virtual Methods
func _ready() -> void:
	if !coyote_timer:
		return
	coyote_timer.one_shot = true
#endregion


#region Public Virtual Methods
func action_start(action_name : StringName) -> void:
	match action_name:
		&"player_jump":
			if (
				!action_cache.get_value(&"has_jumped") &&
				coyote_timer &&
				!coyote_timer.is_stopped()
			):
				coyote_timer.stop()
				force_change(jump_state)
				return
			
			if jump_buffer:
				jump_buffer.start()
func action_finished(action_name : StringName) -> void:
	match action_name:
		&"in_air":
			if jump_buffer && !jump_buffer.is_stopped():
				force_change(jump_state)
				return
			action_cache.set_value(&"has_jumped", false)
			force_change(land_state)
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	if !action_cache.is_action(&"in_air"):
		return land_state
	return null

func enter_state() -> void:
	if !coyote_timer:
		return
	
	if !action_cache.get_value(&"jumped"):
		coyote_timer.start()
#endregion
