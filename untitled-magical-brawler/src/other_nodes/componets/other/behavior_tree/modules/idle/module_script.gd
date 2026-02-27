@tool
extends SequenceComposite


#region External Variables
@export_subgroup("Modules")
@export var task : TaskNode:
	set = set_task
#endregion


#region OnReady Variables
@onready var _slowdown_task: Node = %SlowdownTask
#endregion



#region Virtual Methods
func _ready() -> void:
	set_task(task)
#endregion


#region Setter Methods
func set_task(val : TaskNode) -> void:
	task = val
	if !is_node_ready():
		return
	_slowdown_task.task = task
#endregion
