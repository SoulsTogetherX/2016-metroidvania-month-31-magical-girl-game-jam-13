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
	var velocity_c := get_velocity(args)
	var get_move_dir : Callable = args.get(&"get_move_dir")
	var is_on_ground : Callable = args.get(&"is_on_ground")
	
	var acceleration : float = get_move_dir.call()
	var speed : float = get_move_dir.call()
	var weight : float = 0.0

	if is_on_ground.is_null() || !is_on_ground.is_valid() || is_on_ground.call():
		acceleration *= args.get(
			&"ground_acceleration", ground_acceleration
		)
		speed *= args.get(
			&"ground_max_speed", ground_max_speed
		)
		weight = args.get(
			&"ground_weight", ground_weight
		)
	else:
		acceleration *= args.get(
			&"air_acceleration", air_acceleration
		)
		speed *= args.get(
			&"air_max_speed", air_max_speed
		)
		weight = args.get(
			&"air_weight", air_weight
		)
	
	if signf(speed) != signf(velocity_c.get_velocity().x):
		var s_weight : float = args.get(
			&"slowdown_weight", slowdown_weight
		)
		velocity_c.lerp_hor_change(0.0, s_weight, delta)
	velocity_c.flat_hor_change(acceleration, delta)
	velocity_c.lerp_hor_change(speed, weight, delta)
	
	return true
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	
	var get_move_dir : Callable = args.get(&"get_move_dir", Callable())
	if !get_move_dir.is_valid():
		return false
	
	var is_on_ground : Callable = args.get(&"is_on_ground", Callable())
	if !is_on_ground.is_valid():
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Walk_Task"
#endregion
