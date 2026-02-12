extends State


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var movement : MovementComponent

@export_group("States")
@export var slowdown_state : State
@export var jump_state : State

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
func process_physics(delta: float) -> State:
	if _allow_jump && action_cache.is_jumping():
		return jump_state
	if action_cache.is_on_ground():
		return slowdown_state
	
	movement.horizontal_movement(delta)
	return null
#endregion


#region Public Methods (State Change)
func enter_state() -> void:
	if !coyote_timer:
		return
	
	_allow_jump = true
	coyote_timer.start()
#endregion
