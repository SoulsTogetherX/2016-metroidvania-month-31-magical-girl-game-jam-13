class_name TaskManager extends Node


#region External Variables
@export_group("Settings")
@export var args : Dictionary:
	set(val):
		if val == args:
			return
		args = val
		
		update_tasks_args()
@export var disabled : bool = false:
	set(val):
		if val == disabled:
			return
		disabled = val
		
		_update_proces_mode()
#endregion


#region Private Variables
var _running_tasks : Dictionary[StringName, Task]
var _stored_task : Dictionary[StringName, TaskNode]

var _running : bool = false
#endregion



#region Virtual Methods
func _ready() -> void:
	_register_task_nodes()
	_auto_start_all()
	child_entered_tree.connect(_register_task_node)
	child_exiting_tree.connect(_unregister_task_node)

func _process(delta: float) -> void:
	for task : Task in _running_tasks.values():
		task.task_process(delta)
func _physics_process(delta: float) -> void:
	for task : Task in _running_tasks.values():
		task.task_physics(delta)
#endregion


#region Private Methods (Task Node Register)
func _register_task_nodes() -> void:
	_unregister_task_nodes()
	
	for child : Node in get_children():
		if child is TaskNode:
			_stored_task[child.task_id()] = child
			child._force_start.connect(task_begin)
func _unregister_task_nodes() -> void:
	for task_node : TaskNode in _stored_task.values():
		_stored_task[task_node.task_id()] = task_node
		task_node._force_start.disconnect(task_begin)
	
	_stored_task.clear()

func _register_task_node(node : Node) -> void:
	if node is TaskNode:
		if _stored_task.has(node.task_id()):
			return
		
		_stored_task.set(node.task_id(), node)
		node._force_start.connect(task_begin)
func _unregister_task_node(node : Node) -> void:
	if node is TaskNode:
		if !_stored_task.has(node.task_id()):
			return
	
		_stored_task.erase(node.task_id())
		node._force_start.disconnect(task_begin)
#endregion


#region Private Methods (Helper)
func _auto_start_all() -> void:
	for state : TaskNode in _stored_task.values():
		if state.auto_start:
			task_begin(state.task_id(), state.auto_start_args)

func _create_task(
	managed_state : TaskNode,
	given_args : Dictionary
) -> Task:
	return Task.new(
		managed_state,
		given_args,
		get_args
	)

func _update_proces_mode() -> void:
	var running := !disabled && !_running_tasks.is_empty()
	if running == _running:
		return
	
	set_process(running)
	set_physics_process(running)
#endregion


#region Public Methods (Task)
func task_begin(
	task_id : StringName,
	given_args : Dictionary = {},
	overwrite : bool = false
) -> void:
	if !state_exists(task_id):
		return
	if is_state_running(task_id):
		if !overwrite:
			return
		task_end(task_id)
	
	var node : TaskNode = _stored_task.get(task_id)
	var task : Task = _create_task(node, given_args)
	if !task.task_passthrough():
		return
	
	node._running = true
	task.force_stop.connect(task_end.bind(task_id))
	
	task.task_begin()
	node.task_began.emit()
	_running_tasks.set(task_id, task)
	
	_update_proces_mode()
func task_end(
	task_id : StringName
) -> void:
	if !is_state_running(task_id):
		return
	
	var node : TaskNode = _stored_task.get(task_id)
	var task : Task = _running_tasks.get(task_id)
	task.task_end()
	node._running = false
	
	_running_tasks.erase(task_id)
	_update_proces_mode()


func tap_state(
	task_id : StringName,
	extra_args : Dictionary = {},
	overwrite : bool = false
) -> void:
	if !state_exists(task_id):
		return
	if is_state_running(task_id):
		if !overwrite:
			return
		task_end(task_id)
	
	var node : TaskNode = _stored_task.get(task_id)
	var total_args := get_args().merged(extra_args)
	
	if !node.task_passthrough(total_args):
		return
	node.task_begin()
	node.task_end()

func task_disable(task_id : StringName, toggle : bool) -> void:
	if !state_exists(task_id):
		return
	
	var state : TaskNode = _stored_task.get(task_id)
	state.disabled = toggle
#endregion


#region Public Methods (Checks)
func is_state_running(task_id : StringName) -> bool:
	return _running_tasks.has(task_id)
func state_exists(task_id : StringName) -> bool:
	return _stored_task.has(task_id)
#endregion


#region Public Methods (Helper)
func update_tasks_args() -> void:
	for task : Task in _running_tasks.values():
		task.update_arg_cache()

func get_args() -> Dictionary:
	return args
#endregion


#region Inner Classes
class Task:
	#region Signals
	signal force_stop
	#endregion
	
	#region Private Variables
	var _node : TaskNode
	var _extra_args : Dictionary
	var _arg_cache : Dictionary
	
	var _get_base_args : Callable
	#endregion
	
	
	#region Virtual Methods
	func _init(
		managed_node : TaskNode,
		given_args : Dictionary,
		get_base_args : Callable
	) -> void:
		_extra_args  = given_args
		_node = managed_node
		_get_base_args = get_base_args
		
		_node._force_end.connect(force_stop.emit)
		update_arg_cache()
	#endregion
	
	#region Public Virtual Methods
	func task_process(delta : float) -> bool:
		if _node.disabled:
			return true
		return _node.task_process(delta)
	func task_physics(delta : float) -> bool:
		if _node.disabled:
			return true
		return _node.task_physics(delta)
	#endregion

	#region Public Methods (Action States)
	func task_passthrough() -> bool:
		return _node.task_passthrough(_arg_cache)
	func task_begin() -> void:
		_node.task_begin()
	func task_end() -> void:
		_node.task_end()
		_node.task_finished.emit()
	#endregion

	#region Public Methods (Helper)
	func update_arg_cache() -> void:
		_arg_cache = (
			_get_base_args.call() as Dictionary
		).merged(_extra_args, true)
	#endregion
