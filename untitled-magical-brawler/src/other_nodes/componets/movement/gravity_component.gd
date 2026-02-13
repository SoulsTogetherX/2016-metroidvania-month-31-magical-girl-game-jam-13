class_name GravityComponent extends Node


#region External Variables
@export_group("Settings")
@export var gravity : float = 4000
@export var gravity_max_speed : float = 8000
@export var gravity_weight : float = 0.8
#endregion


#region Public Variables
var _is_falling : bool = false
#endregion



#region Virtual Methods
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


#region Public Methods (Helper)
func get_jump_impulse(height : float) -> float:
	return -sqrt(2 * gravity * height)
func get_max_jump_height(impulse : float) -> float:
	return pow(impulse, 2) / (2 * gravity)
#endregion
