extends ManagedTaskState


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
func state_physics(delta : float, args : Dictionary) -> bool:
	var velocity := get_velocity(args)
	var get_move_dir : Callable = args.get(&"get_move_dir")
	var is_on_ground : Callable = args.get(&"is_on_ground")
	
	var acceleration : float = get_move_dir.call()
	var speed : float = get_move_dir.call()
	var weight : float = 0.0

	if is_on_ground.is_null() || !is_on_ground.is_valid() || is_on_ground.call():
		acceleration *= ground_acceleration
		speed *= ground_max_speed
		weight = ground_weight
	else:
		acceleration *= air_acceleration
		speed *= air_max_speed
		weight = air_weight

	if signf(speed) != signf(velocity.get_velocity().x):
		velocity.lerp_hor_change(0.0, slowdown_weight, delta)
	velocity.flat_hor_change(acceleration, delta)
	velocity.lerp_hor_change(speed, weight, delta)
	
	return true
#endregion
	

#region Public Methods (Action States)
func begin_state(args : Dictionary) -> bool:
	return get_velocity(args) != null
#endregion


#region Public Methods (Identifier)
func state_id() -> StringName:
	return &"Walk_Task"
#endregion
