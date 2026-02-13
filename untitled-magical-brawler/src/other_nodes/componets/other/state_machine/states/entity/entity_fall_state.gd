extends MachineState


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var task : TaskManager

@export_group("States")
@export var slowdown_state : MachineState
@export var jump_state : MachineState

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
func process_physics(_delta: float) -> MachineState:
	if _allow_jump && action_cache.is_jumping():
		return jump_state
	if action_cache.is_on_ground():
		return slowdown_state
	return null
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	if !coyote_timer:
		return
	
	_allow_jump = true
	coyote_timer.start()
	task.begin_task(
		&"Walk_Task",
		{
			&"get_move_dir": action_cache.get_move_direction,
			&"is_on_ground": action_cache.is_on_ground
		}
	)
func exit_state() -> void:
	task.end_task(&"Walk_Task")
#endregion
