@abstract
class_name ManagedTaskState extends ManagedState


#region Public Methods (Helper)
func get_velocity(args : Dictionary) -> VelocityComponent:
	return args.get(TaskManager.VELOCITY_NAME)
#endregion
