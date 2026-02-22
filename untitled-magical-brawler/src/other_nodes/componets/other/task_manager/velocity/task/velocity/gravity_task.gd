extends VelocityTaskNode


#region External Variables
@export_group("Modules")
@export var gravity_module : GravityComponent
#endregion


#region Private Variables
var _on_floor : Callable

var _gravity_module : GravityComponent
#endregion



#region Public Virtual Methods
func task_physics(delta : float) -> void:
	var on_floor : bool = _on_floor.call()
	
	_gravity_module.handle_gravity(
		velocity_module, !on_floor, delta
	)
#endregion


#region Public Methods (Action States)
func task_passthrough() -> bool:
	_gravity_module = args.get(&"gravity", gravity_module)
	if _gravity_module == null:
		return false
	_on_floor = args.get(&"on_floor", Callable())
	if !_on_floor.is_valid() || !(_on_floor.call() is bool):
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Gravity_Task"
#endregion
