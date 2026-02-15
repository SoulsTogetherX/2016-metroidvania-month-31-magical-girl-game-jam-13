extends VelocityTaskNode


#region External Variables
@export_group("Settings")
@export var jump_offset := Vector2(0.0, 400.0)
@export var jump_stopper_weight : float = 0.9
@export_flags("Replace y:1", "Replace x:2") var replace_mask : int = 1

@export_group("Modules")
@export var gravity_c : GravityComponent
#endregion



#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	var velocity_c := get_velocity(args)
	if velocity_c == null:
		return false
	
	var grav : GravityComponent = get_argument(
		args, &"gravity", gravity_c
	)
	if grav == null:
		return false
	
	var offset : Vector2 = get_argument(
		args, &"jump_offset", jump_offset
	)
	var mask : int = get_argument(
		args, &"replace_mask", replace_mask
	)
	var impluse := GravityComponent.get_required_trajectory_impulse(
		grav.gravity,
		offset
	)
	
	## Replace Y
	if (mask & 1):
		velocity_c.velocity.y = impluse.y
	else:
		velocity_c.velocity.y += impluse.y
	
	## Replace X
	if (mask & 2):
		velocity_c.velocity.x = impluse.x
	else:
		velocity_c.velocity.x += impluse.x
	
	return true
func task_end(args : Dictionary) -> void:
	var velocity_c := get_velocity(args)
	var stopper : float = get_argument(
		args, &"jump_stopper_weight", jump_stopper_weight
	)
	
	if !velocity_c.attempting_fall():
		velocity_c.lerp_ver_change(0.0, stopper, 1.0)
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Jump_Task"
#endregion
