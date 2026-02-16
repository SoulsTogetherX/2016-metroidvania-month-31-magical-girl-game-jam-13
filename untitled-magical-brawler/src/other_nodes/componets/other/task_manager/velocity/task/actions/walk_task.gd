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



#region Public Virtual Methods
func task_physics(delta : float, args : Dictionary) -> bool:
	var velocity_module := get_velocity(args)
	var move_dir : float = get_argument(
		args, &"move_dir", Callable()
	)
	var on_floor : bool = get_argument(
		args, &"on_floor", Callable()
	)
	
	var acceleration : float = move_dir
	var speed : float = move_dir
	var weight : float = 0.0

	if on_floor:
		acceleration *= get_argument(
			args, &"ground_acceleration", ground_acceleration
		)
		speed *= get_argument(
			args, &"ground_max_speed", ground_max_speed
		)
		weight = get_argument(
			args, &"ground_weight", ground_weight
		)
	else:
		acceleration *= get_argument(
			args, &"air_acceleration", air_acceleration
		)
		speed *= get_argument(
			args, &"air_max_speed", air_max_speed
		)
		weight = get_argument(
			args, &"air_weight", air_weight
		)
	
	if signf(speed) != signf(velocity_module.get_velocity().x):
		var s_weight : float = get_argument(
			args, &"slowdown_weight", slowdown_weight
		)
		velocity_module.lerp_hor_change(0.0, s_weight, delta)
	
	velocity_module.flat_hor_change(acceleration, delta)
	velocity_module.lerp_hor_change(speed, weight, delta)
	
	return true
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	if !(get_argument(args, &"move_dir", Callable()) is float):
		return false
	if !(get_argument(args, &"on_floor", Callable()) is bool):
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Walk_Task"
#endregion
