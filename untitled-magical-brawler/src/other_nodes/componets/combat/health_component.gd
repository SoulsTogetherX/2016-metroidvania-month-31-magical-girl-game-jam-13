class_name HealthComponent extends Node

#region Signals
signal max_health_changed(max_health : int)
signal max_health_delta(delta : int)
signal health_changed(health : int)
signal health_delta(delta : int)

signal damaged(delta : int)
signal healed(delta : int)
signal dead
signal revived
#endregion


#region External Variables
@export var max_health : int = 10:
	get = get_max_health,
	set = set_max_health
#endregion


#region Private Variables
var _max_health : int
var _health : int
#endregion


#region Public Variables
var current_health : int:
	get = get_health,
	set = set_health
#endregion



#region Virtual Methods
func _init() -> void:
	initialize_health()
#endregion


#region Max Health Methods
func get_max_health() -> int:
	return _max_health
func set_max_health(val : int) -> void:
	val = maxi(0, val)
	if val == _max_health:
		return
	var delta := val - _max_health
	
	_max_health = val
	if _health > _max_health:
		_health = _max_health
	
	max_health_changed.emit(_max_health)
	max_health_delta.emit(delta)
func set_max_health_no_signal(val : int) -> void:
	_max_health = maxi(0, val)
#endregion


#region Health Methods
func initialize_health() -> void:
	_health = _max_health

func get_health() -> int:
	return _health

func set_health_no_signal(val : int) -> void:
	_health = clampi(val, 0, max_health)
func set_health(val : int) -> void:
	val = clampi(val, 0, max_health)
	if val == _health:
		return
	var delta := val - _health
	_health = val
	
	health_changed.emit(_health)
	health_delta.emit(delta)
	if delta < 0:
		damaged.emit(-delta)
		if val == 0:
			dead.emit()
		return
	
	healed.emit(delta)
	if delta == val:
		revived.emit()
#endregion


#region Delta Methods
func damage(delta : int) -> void:
	current_health = _health - delta
func heal(delta : int) -> void:
	current_health = _health + delta
#endregion


#region Generic Setters
func kill() -> void:
	if is_dead():
		return
	
	_health = 0
	damaged.emit()
	dead.emit()
func full_heal() -> void:
	if _max_health == 0 || _health == _max_health:
		return
	var revived_check := is_dead()
	
	_health = _max_health
	healed.emit()
	if revived_check:
		revived.emit()
#endregion


#region Other
func is_dead() -> bool:
	return _health > 0
#endregion
