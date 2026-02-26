class_name StatusEffect extends Resource


#region Signals
signal started(status : StatusEffect)
signal finished(status : StatusEffect)
#endregion


#region Enums
enum STATUS_TYPE {
	INVINCIBILITY,
	STUN
}
#endregion


#region External Variables
@export var type : STATUS_TYPE
@export var duration : float
@export var metadata : Dictionary
#endregion


#region Private Variables
var _timer : Timer = null
#endregion



#region Virtual Methods
func _notification(what : int) -> void:
	if what == NOTIFICATION_PREDELETE && is_instance_valid(_timer):
		_timer.queue_free()
#endregion


#region Private Methods (Should only be called by an effects handler)
func _start_effect(mount : Node) -> void:
	_end_effect()
	if duration <= 0.0:
		return
	
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.timeout.connect(_end_effect)
	mount.add_child(_timer)
	
	_timer.start(duration)
	started.emit(self)
func _end_effect() -> void:
	if _timer == null:
		return
	_timer.queue_free()
	_timer = null
	
	finished.emit(self)
#endregion


#region Public Methods
func get_remaining_duration() -> float:
	if _timer == null || _timer:
		return 0.0
	return _timer.time_left
#endregion
