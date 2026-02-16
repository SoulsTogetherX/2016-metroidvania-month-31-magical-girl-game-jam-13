class_name KnockbackComponent extends Node


#region External Variables
@export var velocity_module : VelocityComponent
#endregion



#region Public Methods
func enact_knockback(
	dir : Vector2,
	overwrite_x : bool = false,
	overwrite_y : bool = false
) -> void:
	if !velocity_module:
		push_error("Could not find 'VelocityComponent'")
		return
	
	if !overwrite_x:
		dir.x += velocity_module.velocity.x
	if !overwrite_y:
		dir.y += velocity_module.velocity.y
	velocity_module.velocity = dir
#endregion
