extends VelocityTaskNode


#region External Variables
@export_group("Modules")
@export var gravity_module : GravityComponent
#endregion


#region Private Variables
var _gravity_module : GravityComponent
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Virtual Methods
func task_physics(delta : float) -> void:
	_gravity_module.handle_gravity(
		velocity_module, delta
	)
#endregion


#region Public Methods (Action States)
func task_passthrough() -> bool:
	_gravity_module = args.get(&"gravity", gravity_module)
	if _gravity_module == null:
		return false
	
	return true
#endregion
