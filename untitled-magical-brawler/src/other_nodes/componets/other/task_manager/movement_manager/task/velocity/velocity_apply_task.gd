extends VelocityTaskNode


#region External Variables
@export_group("Other")
@export var actor : CharacterBody2D
#endregion



#region Public Virtual Methods
func state_physics(_delta : float, args : Dictionary) -> bool:
	var velocity := get_velocity(args)
	velocity.apply_velocity(actor)
	return true
#endregion
	

#region Public Methods (Action States)
func begin_state(args : Dictionary) -> bool:
	return actor != null && get_velocity(args) != null
#endregion


#region Public Methods (Identifier)
func state_id() -> StringName:
	return &"Velocity_Apply_Task"
#endregion
