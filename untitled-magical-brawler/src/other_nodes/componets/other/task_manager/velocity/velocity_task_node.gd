@abstract
class_name VelocityTaskNode extends TaskNode


#region Public Methods (Helper)
func get_velocity(args : Dictionary) -> VelocityComponent:
	return args.get(VelocityTaskManager.VELOCITY_NAME)
#endregion
