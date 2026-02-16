class_name MovementComponent extends Node


#region External Variables
@export_group("Settings")
@export_subgroup("Jump")
@export var jump_height : float = 400
@export var jump_stopper_weight : float = 0.9
@export_subgroup("Ground")
@export var ground_acceleration : float = 2000
@export var ground_max_speed : float = 5000
@export var ground_weight : float = 1.0
@export_subgroup("Air")
@export var air_acceleration : float = 2000
@export var air_max_speed : float = 5000
@export var air_weight : float = 0.7
@export_subgroup("Slowdown")
@export var slowdown_flat : float = 100.0
@export var slowdown_weight : float = 20.0


@export_group("Modules")
@export var velocity_module: VelocityComponent
@export var gravity_module: GravityComponent
@export var action_cache_module : ActionCacheComponent
#endregion



#region Public Methods (Jump)
func jump() -> void:
	if !velocity_module || !gravity_module:
		return
	
	velocity_module.velocity.y = gravity_module.get_inital_impulse(jump_height)
func stop_jump() -> void:
	if !velocity_module:
		return
	
	if !velocity_module.attempting_fall():
		velocity_module.velocity.y = Utilities.dampf(
			velocity_module.velocity.y, 0.0, jump_stopper_weight, 1.0
		)
#endregion


#region Public Methods (Horizontal Movement)
func stop_horizontal_movement() -> void:
	if !velocity_module:
		return
	velocity_module.velocity.x = 0.0
func horizontal_movement(delta: float) -> void:
	if !velocity_module || !action_cache_module:
		return
	
	var acceleration : float = action_cache_module.get_move_direction()
	var speed : float = action_cache_module.get_move_direction()
	var weight : float = 0.0

	if action_cache_module.is_action(&"on_floor"):
		acceleration *= ground_acceleration
		speed *= ground_max_speed
		weight = ground_weight
	else:
		acceleration *= air_acceleration
		speed *= air_max_speed
		weight = air_weight

	if signf(speed) != signf(velocity_module.velocity.x):
		velocity_module.lerp_hor_change(0.0, slowdown_weight, delta)
	velocity_module.flat_hor_change(acceleration, delta)
	velocity_module.lerp_hor_change(speed, weight, delta)
func horizontal_slowdown(delta: float) -> void:
	if !velocity_module:
		return
	var dir := velocity_module.hor_direction()
	
	velocity_module.lerp_hor_change(
		0.0,
		slowdown_weight,
		delta
	)
	
	if !action_cache_module:
		return
	
	velocity_module.flat_hor_change(-slowdown_flat * dir, delta)
	if dir < 0:
		velocity_module.min_hor_velocity(0.0)
	elif dir > 0:
		velocity_module.max_hor_velocity(0.0)
#endregion


#region Public Methods (Gravity)
func handle_gravity(delta : float) -> void:
	if !gravity_module:
		return
	
	gravity_module.handle_gravity(
		velocity_module,
		!action_cache_module.is_action(&"on_floor"),
		delta
	)
#endregion


#region Public Methods (Apply)
func apply_velocity(body : CharacterBody2D) -> void:
	if !velocity_module:
		return
	velocity_module.apply_velocity(body)
#endregion
