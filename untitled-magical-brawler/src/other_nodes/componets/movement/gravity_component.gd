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
	gravity_val : float,
	height : float
) -> float:
	return -sqrt(2 * gravity_val * height)
## Untested
static func get_required_trajectory_impulse(
	gravity_val : float,
	positon : Vector2
) -> Vector2:
	if positon.x == 0.0:
		return Vector2(
			0,
			get_trajectory_impulse(gravity_val, positon.y)
		)
	
	var temp := positon.y + positon.length()
	return Vector2.ONE.rotated(
		atan(temp / positon.x)
	) * sqrt(gravity_val * temp)
## Untested
static func get_required_trajectory_impulse_for_angle(
	gravity_val : float,
	positon : Vector2,
	angle : float
) -> float:
	var cos_angle := cos(angle)
	var tan_angle := tan(angle)
	
	return sqrt(
		(gravity_val * positon.x * positon.x) /
		(2 * cos_angle * cos_angle * (positon.x * tan_angle - positon.y))
	)

static func get_trajectory_max_height(
	gravity_val : float,
	impulse : float
) -> float:
	return pow(impulse, 2) / (2 * gravity_val)
static func get_trajectory_max_height_impulsed(
	gravity_val : float,
	impulse : Vector2
) -> float:
	return get_trajectory_max_height(gravity_val, impulse.y)

static func get_offset(
	gravity_val : float,
	time : float,
	impulse : Vector2
) -> Vector2:
	var offset := time * impulse
	offset.y += (gravity_val * time * time / 2)
	
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
