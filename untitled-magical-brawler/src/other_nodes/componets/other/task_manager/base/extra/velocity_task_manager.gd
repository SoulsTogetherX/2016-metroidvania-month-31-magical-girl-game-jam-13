class_name VelocityTaskManager extends TaskManager


#region Constants
const VELOCITY_NAME := &"__velocity_component__"
#endregion


#region External Variables
@export_group("Modules")
@export var velocity_module: VelocityComponent
#endregion



#region Ready Methods
func _ready() -> void:
	super()
	if !velocity_module:
		push_error("No 'VelocityComponent' found")
#endregion


#region Private Methods (Task Cache)
func _task_adjust_args(node : TaskNode, args : Dictionary) -> void:
	if node is VelocityTaskNode:
		node.velocity_module = velocity_module
	node.args = args
#endregion
