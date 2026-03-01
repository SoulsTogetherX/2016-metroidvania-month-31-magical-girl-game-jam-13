extends VelocityTaskNode


#region External Variables
@export_group("Other")
@export var actor : CharacterBody2D
#endregion


#region Private Variables
var _actor : CharacterBody2D
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Private Methods
func _connect_velocity_check() -> void:
	set_disabled(true)
	if !velocity_module.velocity_changed.is_connected(_velocity_changes):
		velocity_module.velocity_changed.connect(_velocity_changes)
func _disconnect_velocity_check() -> void:
	set_disabled(false)
	if velocity_module.velocity_changed.is_connected(_velocity_changes):
		velocity_module.velocity_changed.disconnect(_velocity_changes)
#endregion


#region Private Methods (Velocity Check)
func _velocity_changes() -> void:
	if velocity_module.velocity.is_zero_approx():
		return
	_disconnect_velocity_check()
#endregion


#region Public Virtual Methods
func task_physics(_delta : float) -> void:
	if velocity_module.velocity.is_zero_approx():
		_connect_velocity_check()
		return
	velocity_module.apply_velocity(_actor)
#endregion
	

#region Public Methods (Action States)
func task_passthrough() -> bool:
	_actor = args.get(&"actor", actor)
	if _actor == null:
		return false
	return true

func task_begin() -> void:
	_velocity_changes()
func task_end() -> void:
	_disconnect_velocity_check()
#endregion
