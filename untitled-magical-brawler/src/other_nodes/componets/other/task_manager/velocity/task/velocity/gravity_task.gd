extends VelocityTaskNode


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent
@export var gravity_module : GravityComponent
#endregion


#region Private Variables
var _action_cache : ActionCacheComponent

var _gravity_module : GravityComponent
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Private Methods
func _action_finished(action_name : StringName) -> void:
	match action_name:
		&"on_floor":
			_action_cache.action_finished.disconnect(_action_finished)
			set_disabled(false)
#endregion


#region Public Virtual Methods
func task_physics(delta : float) -> void:
	var on_floor := _action_cache.is_action(&"on_floor")
	if on_floor:
		set_disabled(true)
		_action_cache.action_finished.connect(_action_finished)
		return
	
	_gravity_module.handle_gravity(
		velocity_module, delta
	)
#endregion


#region Public Methods (Action States)
func task_passthrough() -> bool:
	_gravity_module = args.get(&"gravity", gravity_module)
	if _gravity_module == null:
		return false
	_action_cache = args.get(&"action_cache", action_cache)
	if _action_cache == null:
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Gravity_Task"
#endregion
