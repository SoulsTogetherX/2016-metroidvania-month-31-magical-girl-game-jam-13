class_name VelocityTaskManager extends TaskManager


#region Constants
const VELOCITY_NAME := &"__velocity_component__"
#endregion


#region External Variables
@export_group("Modules")
@export var velocity_c: VelocityComponent
#endregion



#region Private Methods (Helper)
func _create_task(
	managed_state : TaskNode,
	given_args : Dictionary
) -> Task:
	return Task.new(
		managed_state,
		given_args,
		get_velocity_args if (managed_state is VelocityTaskNode) else get_args
	)
#endregion


#region Public Methods (Helper)
func get_velocity_args() -> Dictionary:
	return args.merged(
		{
			VELOCITY_NAME: velocity_c
		}
	)
#endregion
