extends VelocityTaskNode


#region External Variables
@export_group("Settings")
@export var jump_height : float = 400
@export var jump_stopper_weight : float = 0.9

@export_group("Modules")
@export var gravity : GravityComponent
#endregion



#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	var velocity := get_velocity(args)
	if !velocity:
		return false
	
	velocity.force_velocity_y(
		GravityComponent.get_trajectory_impulse(
			gravity.gravity,
			jump_height
		)
	)
	return true
func task_end(args : Dictionary) -> void:
	var velocity := get_velocity(args)
	
	if !velocity.attempting_fall():
		velocity.lerp_ver_change(0.0, jump_stopper_weight)
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Jump_Task"
#endregion
