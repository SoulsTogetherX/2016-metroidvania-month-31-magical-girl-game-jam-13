extends VelocityTaskNode


#region External Variables
@export_group("Ground")
@export var ground_acceleration : float = 2000
@export var ground_max_speed : float = 5000
@export var ground_weight : float = 1.0

@export_group("Air")
@export var air_acceleration : float = 2000
@export var air_max_speed : float = 5000
@export var air_weight : float = 0.7

@export_group("Slowdown")
@export var slowdown_weight : float = 20.0
#endregion


#region Private Variables
var _move_dir : Callable
var _on_floor : Callable

var _ground_acceleration : float
var _ground_max_speed : float
var _ground_weight : float

var _air_acceleration : float
var _air_max_speed : float
var _air_weight : float

var _slowdown_weight : float
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Virtual Methods
func task_physics(delta : float) -> void:
	var move_dir : float = _move_dir.call()
	var on_floor : bool = _on_floor.call()
	
	var acceleration : float = move_dir
	var speed : float = move_dir
	var weight : float = 0.0

	if on_floor:
		acceleration *= _ground_acceleration
		speed *= _ground_max_speed
		weight = _ground_weight
	else:
		acceleration *= _air_acceleration
		speed *= _air_max_speed
		weight = _air_weight
	
	if signf(speed) != signf(velocity_module.get_velocity().x):
		velocity_module.lerp_hor_change(
			0.0, _slowdown_weight, delta
		)
	
	velocity_module.flat_hor_change(acceleration, delta)
	velocity_module.lerp_hor_change(speed, weight, delta)
#endregion
	

#region Public Methods (Action States)
func task_passthrough() -> bool:
	_move_dir = args.get("move_dir", Callable())
	if !_move_dir.is_valid() || !(_move_dir.call() is int):
		return false
	_on_floor = args.get("on_floor", Callable())
	if !_on_floor.is_valid() || !(_on_floor.call() is bool):
		return false
	
	_ground_acceleration = args.get("ground_acceleration", ground_acceleration)
	_ground_max_speed = args.get("ground_max_speed", ground_max_speed)
	_ground_weight = args.get("ground_weight", ground_weight)
	
	_air_acceleration = args.get("air_acceleration", air_acceleration)
	_air_max_speed = args.get("air_max_speed", air_max_speed)
	_air_weight = args.get("air_weight", air_weight)

	_slowdown_weight = args.get("slowdown_weight", slowdown_weight)
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Walk_Task"
#endregion
