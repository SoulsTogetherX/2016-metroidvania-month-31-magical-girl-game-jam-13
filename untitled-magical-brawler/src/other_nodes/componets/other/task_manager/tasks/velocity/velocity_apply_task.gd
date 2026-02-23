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


#region Private Methods (Velocity Check)
func _velocity_changes() -> void:
	if velocity_module.velocity.is_zero_approx():
		set_disabled(true)
		velocity_module.velocity_changed.connect(
			set_disabled.bind(false),
			CONNECT_ONE_SHOT
		)
		return
#endregion


#region Public Virtual Methods
func task_physics(_delta : float) -> void:
	velocity_module.apply_velocity(_actor)
#endregion
	

#region Public Methods (Action States)
func task_passthrough() -> bool:
	_actor = args.get(&"actor", actor)
	if _actor == null:
		return false
	return true

func task_begin() -> void:
	velocity_module.velocity_changed.connect(_velocity_changes)
func task_end() -> void:
	velocity_module.velocity_changed.disconnect(_velocity_changes)
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Velocity_Apply_Task"
#endregion
