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
@export var velocity: VelocityComponent
@export var gravity: GravityComponent
@export var action_cache : ActionCacheComponent
#endregion



#region Public Methods (Jump)
func jump() -> void:
	if !velocity || !gravity:
		return
	
	velocity.force_velocity_y(gravity.get_inital_impulse(jump_height))
func stop_jump() -> void:
	if !velocity:
		return
	
	if !velocity.attempting_fall():
		velocity.lerp_ver_change(0.0, jump_stopper_weight)
#endregion


#region Public Methods (Horizontal Movement)
func stop_horizontal_movement() -> void:
	if !velocity:
		return
	velocity.force_velocity_x(0.0)
func horizontal_movement(delta: float) -> void:
	if !velocity || !action_cache:
		return
	var acceleration : float = action_cache.get_move_direction()
	var speed : float = action_cache.get_move_direction()
	var weight : float = 0.0

	if action_cache.is_on_ground():
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
func horizontal_slowdown(delta: float) -> void:
	if !velocity:
		return
	var dir := velocity.move_direction().x
	
	velocity.lerp_hor_change(
		0.0,
		slowdown_weight,
		delta
	)
	
	if !action_cache:
		return
	
	velocity.flat_hor_change(-slowdown_flat * dir, delta)
	if dir < 0:
		velocity.min_hor_velocity(0.0)
	elif dir > 0:
		velocity.max_hor_velocity(0.0)
#endregion


#region Public Methods (Gravity)
func handle_gravity(delta : float) -> void:
	if !gravity:
		return
	
	gravity.handle_gravity(
		velocity,
		!action_cache.is_on_ground(),
		delta
	)
#endregion


#region Public Methods (Apply)
func apply_velocity(body : CharacterBody2D) -> void:
	if !velocity:
		return
	velocity.apply_velocity(body)
#endregion
