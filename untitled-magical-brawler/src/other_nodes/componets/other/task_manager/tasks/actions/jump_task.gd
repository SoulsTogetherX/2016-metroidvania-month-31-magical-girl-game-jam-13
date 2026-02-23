extends VelocityTaskNode


#region External Variables
@export_group("Settings")
@export var jump_offset := Vector2(0.0, 400.0)
@export var jump_stopper_weight : float = 0.9
@export_flags("Replace y:1", "Replace x:2") var replace_mask : int = 1

@export_group("Modules")
@export var gravity_module : GravityComponent
#endregion


#region Private Variables
var _jump_offset : Vector2
var _jump_stopper_weight : float
var _replace_mask : int

var _gravity_module : GravityComponent
#endregion



#region Public Methods (Action States)
func task_passthrough() -> bool:
	_gravity_module = args.get(&"gravity", gravity_module)
	if _gravity_module == null:
		return false
	
	_jump_offset = args.get(&"jump_offset", jump_offset)
	_jump_stopper_weight = args.get(&"jump_stopper_weight", jump_stopper_weight)
	_replace_mask = args.get(&"replace_mask", replace_mask)
	
	return true

func task_begin() -> void:
	var impluse := GravityComponent.get_required_trajectory_impulse(
		_gravity_module.gravity, _jump_offset
	)
	
	## Replace Y
	if (_replace_mask & 1):
		velocity_module.velocity.y = impluse.y
	else:
		velocity_module.velocity.y += impluse.y
	
	## Replace X
	if (_replace_mask & 2):
		velocity_module.velocity.x = impluse.x
	else:
		velocity_module.velocity.x += impluse.x
func task_end() -> void:
	if !velocity_module.attempting_fall():
		velocity_module.lerp_ver_change(
			0.0, _jump_stopper_weight, 1.0
		)
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Jump_Task"
#endregion
