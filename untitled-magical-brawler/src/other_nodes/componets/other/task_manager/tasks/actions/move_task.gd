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

@export_group("Other")
@export var entity : BaseEntity
@export var stop_raycast : RayCast2D
#endregion


#region Private Variables
var _move_dir : Callable

var _entity : BaseEntity
var _stop_raycast : RayCast2D

var _acceleration : float
var _max_speed : float
var _weight : float

var _slowdown_weight : float
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Virtual Methods
func task_physics(delta : float) -> void:
	var move_dir : float = _move_dir.call()
	if _entity && !is_zero_approx(move_dir):
		_entity.change_direction(move_dir < 0, false)
	
	if _entity && !is_zero_approx(move_dir):
		_entity.change_direction(move_dir < 0, false)
	
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
#endregion
	

#region Public Methods (Action States)
func task_passthrough() -> bool:
	_move_dir = args.get(&"move_dir", Callable())
	if !_move_dir.is_valid() || !(_move_dir.call() is int):
		return false
	
	_entity = args.get(&"entity", entity)
	_stop_raycast = args.get(&"stop_raycast", stop_raycast)
	
	_acceleration = args.get(&"acceleration", acceleration)
	_max_speed = args.get(&"max_speed", max_speed)
	_weight = args.get(&"weight", weight)

	_slowdown_weight = args.get(&"slowdown_weight", slowdown_weight)
	
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
