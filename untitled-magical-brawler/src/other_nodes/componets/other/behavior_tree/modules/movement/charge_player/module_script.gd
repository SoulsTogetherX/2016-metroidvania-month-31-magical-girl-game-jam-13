@tool
extends SelectorReactiveComposite


#region External Variables
@export_subgroup("Modules")
@export var task : TaskNode:
	set = set_task

@export_subgroup("Pursue")
@export_range(0, 100, 0.001, "or_greater") var pursue_forgiveness : float = 20.0:
	set = set_pursue_forgiveness
@export_subgroup("Linger")
@export_range(0, 100, 0.001, "or_greater") var linger_forgiveness : float = 20.0:
	set = set_linge_forgiveness
@export_range(0, 5, 0.001, "or_greater") var linger_duration : float = 2.0:
	set = set_linge_delay
#endregion


#region OnReady Variables
@onready var _go_pursue: Node = %GoToPlayerPursue
@onready var _go_linger: Node = %GoToPlayerLinger
@onready var _delay: DelayDecorator = %DelayDecorator
#endregion



#region Virtual Methods
func _ready() -> void:
	set_task(task)
	set_pursue_forgiveness(pursue_forgiveness)
	set_linge_forgiveness(linger_forgiveness)
	set_linge_delay(linger_duration)
#endregion


#region Setter Methods
func set_task(val : TaskNode) -> void:
	task = val
	if !is_node_ready():
		return
	_go_pursue.task = task
	_go_linger.task = task

func set_pursue_forgiveness(val : float) -> void:
	pursue_forgiveness = val
	if !is_node_ready():
		return
	_go_pursue.forgiveness = pursue_forgiveness
func set_linge_forgiveness(val : float) -> void:
	linger_forgiveness = val
	if !is_node_ready():
		return
	_go_linger.forgiveness = linger_forgiveness

func set_linge_delay(val : float) -> void:
	linger_duration = val
	if !is_node_ready():
		return
	_delay.wait_time = linger_duration
#endregion
