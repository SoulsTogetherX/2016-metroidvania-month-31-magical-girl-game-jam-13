extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_module : ActionCacheComponent

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
func process_physics(_delta: float) -> StateNode:
	return _check_state()
#endregion


#region Public Methods (State Change)
func state_passthrough() -> StateNode:
	return _check_state()
func enter_state() -> void:
	if !coyote_timer:
		return
	
	if !action_cache_module.get_state(&"jumped"):
		coyote_timer.start()
#endregion


#region Private Methods (Helper)
func _check_state() -> StateNode:
	if action_cache_module.is_action_started(&"jumping"):
		if (
			!action_cache_module.get_state(&"has_jumped") &&
			coyote_timer &&
			!coyote_timer.is_stopped()
		):
			coyote_timer.stop()
			return jump_state
		
		if jump_buffer:
			jump_buffer.start()
	
	if action_cache_module.is_action(&"on_floor"):
		if jump_buffer && !jump_buffer.is_stopped():
			return jump_state
		
		action_cache_module.set_state(&"has_jumped", false)
		return land_state
	
	return null
#endregion
