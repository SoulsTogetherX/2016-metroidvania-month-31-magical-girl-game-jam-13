extends VelocityTaskNode


#region External Variables
@export_group("Movement")
@export var acceleration : float = 2000
@export var max_speed : float = 5000
@export var weight : float = 1.0

@export_group("Slowdown")
@export var slowdown_weight : float = 20.0
#endregion


#region Private Variables
var _move_dir : Callable

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
	
	if signf(move_dir) != signf(velocity_module.get_velocity().x):
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
	_move_dir = args.get("move_dir", Callable())
	if !_move_dir.is_valid() || !(_move_dir.call() is int):
		return false
	
	_acceleration = args.get("acceleration", acceleration)
	_max_speed = args.get("max_speed", max_speed)
	_weight = args.get("weight", weight)

	_slowdown_weight = args.get("slowdown_weight", slowdown_weight)
	return true
#endregion
