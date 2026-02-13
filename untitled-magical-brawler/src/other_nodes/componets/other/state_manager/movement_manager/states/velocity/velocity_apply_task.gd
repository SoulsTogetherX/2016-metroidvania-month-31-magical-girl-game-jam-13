extends ManagedTaskState


#region External Variables
@export_group("Modules")
@export var velocity : VelocityComponent

@export_group("Other")
@export var actor : CharacterBody2D
#endregion



#region Public Virtual Methods
func state_physics(_delta : float, _args : Dictionary) -> bool:
	velocity.apply_velocity(actor)
	return true
#endregion
	

#region Public Methods (Action States)
func begin_state(_args : Dictionary) -> bool:
	return actor != null && velocity != null
#endregion


#region Public Methods (Identifier)
func state_id() -> StringName:
	return &"Velocity_Apply_Task"
#endregion
