extends StateNode


#region External Variables
@export_group("Modules")
@export var action_cache_c : ActionCacheComponent
@export var task : VelocityTaskManager

@export_group("States")
@export var slowdown_state : StateNode
@export var jump_state : StateNode

@export_group("Other")
@export var coyote_timer : Timer
#endregion


#region Private Variables
var _allow_jump : bool
#endregion



#region Virtual Methods
func _ready() -> void:
	if !coyote_timer:
		return
	
	coyote_timer.one_shot = true
	coyote_timer.timeout.connect(_disallow_jump)
#endregion


#region Private Methods
func _disallow_jump() -> void:
	_allow_jump = false
#endregion


#region Public Virtual Methods
func process_physics(_delta: float) -> StateNode:
	if _allow_jump && action_cache_c.is_jumping():
		return jump_state
	if action_cache_c.is_on_ground():
		return slowdown_state
	return null
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	if !coyote_timer:
		return
	
	_allow_jump = true
	coyote_timer.start()
	task.task_begin(
		&"Walk_Task",
		{
			&"get_move_dir": action_cache_c.get_move_direction,
			&"is_on_ground": action_cache_c.is_on_ground
		}
	)
func exit_state() -> void:
	task.task_end(&"Walk_Task")
#endregion
