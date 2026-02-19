class_name InvincibilityComponent extends Node


#region Signals
signal begin_invinciblity
signal end_invinciblity
signal invinciblity_stack_changed(stack : int)
#endregion


#region External Variables
@export_group("Settings")
@export_range(
	0.001, 5.0, 0.001, "or_greater"
) var default_duration : float = 1.0
@export_range(-1, -1, 1, "or_greater") var max_stack : int = -1
#endregion


#region Private Variables
var _timer : Timer

var _invinciblity_stack : int = 0
var _invinciblity_queue : bool
#endregion



#region Virtual Methods
func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	
	_timer.timeout.connect(pop_invinciblity)
#endregion


#region Private Methods
func _queue_reached_invincible() -> void:
	_invinciblity_queue = false
	invincible_time()
#endregion


#region Public Methods (Set Invinciblity)
func queue_invinciblity() -> void:
	if _invinciblity_queue:
		return
	_invinciblity_queue = true
	
	call_deferred("_queue_reached_invincible")

func invincible_time(time : float = -1.0) -> void:
	stack_invinciblity()
	if time == -1.0:
		_timer.start(default_duration)
		return
	if time > 0.0:
		_timer.start(time)

func stack_invinciblity() -> void:
	if max_stack == _invinciblity_stack:
		return
	
	_invinciblity_stack += 1
	if _invinciblity_stack == 1:
		begin_invinciblity.emit()
	invinciblity_stack_changed.emit(_invinciblity_stack)
func pop_invinciblity() -> void:
	if _invinciblity_stack == 0:
		push_error("Attempted to pop from an empty invinciblity stack")
		return
	_invinciblity_stack -= 1
	if _invinciblity_stack == 0:
		end_invinciblity.emit()
	invinciblity_stack_changed.emit(_invinciblity_stack)
#endregion



#region Public Methods (Accessors)
func get_invinciblity_stack() -> int:
	return _invinciblity_stack
func is_invincible() -> bool:
	return _invinciblity_stack > 0
#endregion
