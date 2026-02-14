class_name GravityComponent extends Node


#region External Variables
@export_group("Settings")
@export var gravity : float = 4000
@export var gravity_max_speed : float = 8000
@export var gravity_weight : float = 0.8
#endregion


#region Private Variables
var _is_falling : bool = false
#endregion



#region Static Methods (Helper)
static func get_trajectory_impulse(
	gravity_c : float,
	height_c : float
) -> float:
	return -sqrt(2 * gravity_c * height_c)
## Untested
static func get_required_trajectory_impulse(
	gravity_c : float,
	positon_c : Vector2
) -> Vector2:
	var temp := positon_c.y + positon_c.length()
	return Vector2.ONE.rotated(
		atan(temp / positon_c.x)
	) * sqrt(gravity_c * temp)
## Untested
static func get_required_trajectory_impulse_for_angle(
	gravity_c : float,
	positon_c : Vector2,
	angle : float
) -> float:
	var cos_angle := cos(angle)
	var tan_angle := tan(angle)
	
	return sqrt(
		(gravity_c * positon_c.x * positon_c.x) /
		(2 * cos_angle * cos_angle * (positon_c.x * tan_angle - positon_c.y))
	)

static func get_trajectory_max_height(
	gravity_c : float,
	impulse_c : float
) -> float:
	return pow(impulse_c, 2) / (2 * gravity_c)
static func get_trajectory_max_height_impulsed(
	gravity_c : float,
	impulse_c : Vector2
) -> float:
	return get_trajectory_max_height(gravity_c, impulse_c.y)

static func get_offset(
	gravity_c : float,
	time : float,
	impulse_c : Vector2
) -> Vector2:
	var offset := time * impulse_c
	offset.y += (gravity_c * time * time / 2)
	
	return offset
#endregion


#region Public Methods (Helper)
func handle_gravity(
	velocity : VelocityComponent,
	in_air : bool,
	delta: float
) -> void:
	if in_air:
		velocity.flat_ver_change(gravity, delta)
		
		if velocity.attempting_fall() && velocity.get_velocity().y > gravity_max_speed:
			velocity.lerp_ver_change(
				gravity_max_speed,
				gravity_weight,
				delta
			)
	_is_falling = velocity.attempting_fall() && in_air
#endregion


#region Public Methods (Check)
func is_falling() -> bool:
	return _is_falling
#endregion
