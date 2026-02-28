extends HSMModule


#region External Variables
@export_group("Settings")
@export var task : TaskNode
#endregion



#region Public Methods (State Change)
func start_module(act : Node, _ctx : HSMContext) -> void:
	var entity : BaseEntity = act
	entity.start_task(task)
func end_module(act : Node, _ctx : HSMContext) -> void:
	var entity : BaseEntity = act
	entity.end_task(task)
#endregion
