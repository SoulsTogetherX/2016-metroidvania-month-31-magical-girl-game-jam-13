extends VelocityTaskNode


#region External Variables
@export_group("Movement")
@export var acceleration : float = 2000
@export var max_speed : float = 5000
@export var weight : float = 1.0

@export_group("Slowdown")
@export var slowdown_weight : float = 20.0

@export_group("Velocity Reset")
@export var reset_on_begin : bool = false
@export var reset_on_end : bool = false

@export_group("Settings")
@export var auto_change_dir : bool = true

@export_group("Other")
@export var entity : BaseEntity
@export var stop_raycast : RayCast2D
#endregion


#region Private Variables
var _get_target_point : Callable

var _entity : BaseEntity
var _stop_raycast : RayCast2D

var _acceleration : float
var _max_speed : float
var _weight : float

var _slowdown_weight : float

var _auto_change_dir : bool
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Virtual Methods
func task_physics(delta : float) -> void:
	var target_point : Vector2 = _get_target_point.call()
	var move_dir : float = signf(target_point.x - _entity.global_position.x)
	
	if _stop_raycast && !_stop_raycast.is_colliding():
		velocity_module.velocity.x = 0.0
		return
	elif signf(move_dir) != signf(velocity_module.get_velocity().x):
		velocity_module.lerp_hor_change(
			0.0, _slowdown_weight, delta
		)
	
	velocity_module.flat_hor_change(
		move_dir * _acceleration, delta
	)
	velocity_module.lerp_hor_change(
		move_dir * _max_speed, _weight, delta
	)
	
	if auto_change_dir && _entity && !is_zero_approx(move_dir):
		_entity.change_direction(move_dir < 0, false)
#endregion
	

#region Public Methods (Action States)
func task_passthrough() -> bool:
	_get_target_point = args.get(&"get_target_point", Callable())
	if !_get_target_point.is_valid() || !(_get_target_point.call() is Vector2):
		return false
	
	_entity = args.get(&"entity", entity)
	_stop_raycast = args.get(&"stop_raycast", stop_raycast)
	
	_acceleration = args.get(&"acceleration", acceleration)
	_max_speed = args.get(&"max_speed", max_speed)
	_weight = args.get(&"weight", weight)
	
	_slowdown_weight = args.get(&"slowdown_weight", slowdown_weight)
	
	_auto_change_dir = args.get(&"auto_change_dir", auto_change_dir)
	return true

func task_begin() -> void:
	if !reset_on_begin:
		return
	velocity_module.velocity.x = 0.0
func task_end() -> void:
	if !reset_on_end:
		return
	velocity_module.velocity.x = 0.0
#endregion
