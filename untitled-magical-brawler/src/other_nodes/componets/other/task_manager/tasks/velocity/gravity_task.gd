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
func _action_started(action_name : StringName) -> void:
	match action_name:
		&"in_air":
			_action_cache.action_started.disconnect(_action_started)
			set_disabled(false)
#endregion


#region Public Virtual Methods
func task_physics(delta : float) -> void:
	var in_air := _action_cache.is_action(&"in_air")
	if !in_air:
		set_disabled(true)
		_action_cache.action_started.connect(_action_started)
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
func task_begin() -> void:
	set_disabled(false)
#endregion
