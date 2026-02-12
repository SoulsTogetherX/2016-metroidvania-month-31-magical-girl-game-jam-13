class_name VelocityComponent extends Node


#region Private Variables 
var _velocity : Vector2:
	get = get_velocity,
	set = force_velocity
#endregion



#region Static Public Methods (Helper)
static func damp_velocity(
	v1 : Variant,
	v2 : Variant,
	weight : float,
	delta : float
) -> Variant:
	return lerp(v1, v2, 1 - exp(-weight * delta))
#endregion


#region Public Methods (Helper)
func get_velocity() -> Vector2:
	return _velocity
func get_normalized() -> Vector2:
	return _velocity.normalized()

func force_velocity(vec : Vector2) -> void:
	_velocity = vec
func force_velocity_x(val : float) -> void:
	_velocity.x = val
func force_velocity_y(val : float) -> void:
	_velocity.y = val
#endregion


#region Public Methods (Apply Velocity)
func apply_velocity(
	body : CharacterBody2D,
	update : bool = true
) -> void:
	body.velocity = _velocity
	body.move_and_slide()
	
	if update:
		_velocity = body.velocity
#endregion


#region Public Methods (Velocity flat/lerp changes)
func impulse(flat : Vector2) -> void:
	_velocity += flat

func flat_hor_change(flat : float, delta : float = 1.0) -> void:
	_velocity.x += flat * delta
func lerp_hor_change(to : float, weight : float, delta : float = 1.0) -> void:
	_velocity.x = damp_velocity(_velocity.x, to, weight, delta)

func flat_ver_change(flat : float, delta : float = 1.0) -> void:
	_velocity.y += flat * delta
func lerp_ver_change(to : float, weight : float, delta : float = 1.0) -> void:
	_velocity.y = damp_velocity(_velocity.y, to, weight, delta)
#endregion


#region Public Methods (Velocity clamp)
func min_hor_velocity(min_val : float) -> void:
	_velocity.x = minf(_velocity.x, min_val)
func max_hor_velocity(min_val : float) -> void:
	_velocity.x = maxf(_velocity.x, min_val)

func min_ver_velocity(min_val : float) -> void:
	_velocity.y = minf(_velocity.y, min_val)
func max_ver_velocity(min_val : float) -> void:
	_velocity.y = maxf(_velocity.y, min_val)
#endregion


#region Public Methods (Helper)
func is_stationary() -> bool:
	return _velocity.is_zero_approx()

func attempting_fall() -> bool:
	return _velocity.y > 0
func attempting_rise() -> bool:
	return _velocity.y < 0
func attempting_idle() -> bool:
	return is_zero_approx(_velocity.x)

func move_direction() -> float:
	return signf(_velocity.x)
func facing_right() -> bool:
	return _velocity.x > 0
#endregion
