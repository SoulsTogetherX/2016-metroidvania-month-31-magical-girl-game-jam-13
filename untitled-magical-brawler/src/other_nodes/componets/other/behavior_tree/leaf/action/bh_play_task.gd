@tool
extends ActionLeaf


#region External Variables
@export_group("Modules")
@export var task : TaskNode
#endregion



#region Public Methods (State Change)
func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return RUNNING

func before_run(act: Node, _blackboard: Blackboard) -> void:
	var entity : BaseEntity = act
	entity.start_task(task)
func after_run(act: Node, _blackboard: Blackboard) -> void:
	var entity : BaseEntity = act
	entity.end_task(task)

func interrupt(actor: Node, blackboard: Blackboard) -> void:
	after_run(actor, blackboard)
#endregion
