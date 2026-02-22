@abstract
class_name VelocityTaskNode extends TaskNode


#region Public Variables
var velocity_module: VelocityComponent
#endregion



#region Public Methods (Helper)
func get_velocity(args : Dictionary) -> VelocityComponent:
	return args.get(VelocityTaskManager.VELOCITY_NAME)
#endregion
