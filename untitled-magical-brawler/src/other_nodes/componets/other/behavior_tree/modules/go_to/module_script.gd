@tool
extends SequenceReactiveComposite


#region External Variables
@export var task : TaskNode:
	set = set_task
@export_range(0, 100, 0.001, "or_greater") var forgiveness : float = 20.0:
	set = set_forgiveness
#endregion


#region OnReady Variables
@onready var _move_task: ActionLeaf = %WalkToMovingPointTask
@onready var _at_point_check: Node = %AtInterestPoint
#endregion



#region Virtual Methods
func _ready() -> void:
	set_task(task)
	set_forgiveness(forgiveness)
#endregion


#region Setter Methods
func set_task(val : TaskNode) -> void:
	task = val
	if !is_node_ready():
		return
	_move_task.task = task
func set_forgiveness(val : float) -> void:
	forgiveness = val
	if !is_node_ready():
		return
	_at_point_check.forgiveness = forgiveness
#endregion
