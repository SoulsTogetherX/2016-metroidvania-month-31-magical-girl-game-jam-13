class_name TaskManager extends Node


#region External Variables
@export_group("Settings")
@export var disabled : bool = false:
	set(val):
		if val == disabled:
			return
		disabled = val
		
		_update_proces_mode()
#endregion


#region Private Variables
var _physics_cache : Array[TaskNode]
var _process_cache : Array[TaskNode]
var _input_cache : Array[TaskNode]

var _stored_tasks : Dictionary[TaskNode, TaskNode]
#endregion



#region Virtual Methods
func _ready() -> void:
	_register_task_nodes()
	_auto_start_all()
	child_entered_tree.connect(_register_task_node)
	child_exiting_tree.connect(_unregister_task_node)

func _process(delta: float) -> void:
	for task : TaskNode in _process_cache:
		task.task_process(delta)
func _physics_process(delta: float) -> void:
	for task : TaskNode in _physics_cache:
		task.task_physics(delta)
func _unhandled_input(event: InputEvent) -> void:
	for task : TaskNode in _input_cache:
		task.task_input(event)
#endregion


#region Private Methods (Task Node Register)
func _register_task_nodes() -> void:
	_unregister_task_nodes()
	
	for node : Node in get_children():
		if node is TaskNode:
			_stored_tasks.set(node, node)
			_toggle_force_start(node, true)
			_toggle_disable(node, true)
func _unregister_task_nodes() -> void:
	for node : TaskNode in _stored_tasks:
		_toggle_force_start(node, false)
		_toggle_force_stop(node, false)
		_toggle_disable(node, false)
	
	_stored_tasks.clear()
	_task_cache_clear()

func _register_task_node(node : Node) -> void:
	if node is TaskNode:
		if _stored_tasks.has(node):
			return
		
		_stored_tasks.set(node, node)
		node._force_start.connect(task_begin)
		_toggle_force_start(node, true)
		_toggle_disable(node, true)
func _unregister_task_node(node : Node) -> void:
	if node is TaskNode:
		if !_stored_tasks.has(node):
			return
	
		_stored_tasks.erase(node)
		_task_cache_remove(node)
		
		_toggle_force_start(node, false)
		_toggle_force_stop(node, false)
		_toggle_disable(node, false)
#endregion


#region Private Methods (Task Cache)
func _task_adjust_args(node : TaskNode, args : Dictionary) -> void:
	node.args = args

func _task_cache_clear() -> void:
	_physics_cache.clear()
	_process_cache.clear()
	_input_cache.clear()

func _task_cache_add(node : TaskNode) -> void:
	if node.is_disabled() || node.is_running():
		return
	
	if node.need_physics:
		_physics_cache.append(node)
	if node.need_process:
		_process_cache.append(node)
	if node.need_input:
		_input_cache.append(node)
	
	node._running = true
func _task_cache_remove(node : TaskNode) -> void:
	_physics_cache.erase(node)
	_process_cache.erase(node)
	_input_cache.erase(node)
	
	node._running = false

func _update_process_mode(node : TaskNode) -> void:
	_task_cache_remove(node)
	_task_cache_add(node)
#endregion


#region Private Methods (Signal Connection)
func _toggle_force_start(node : TaskNode, toggle : bool) -> void:
	if toggle:
		if !node._force_start.is_connected(task_begin):
			node._force_start.connect(task_begin, CONNECT_DEFERRED)
		return
	if node._force_start.is_connected(task_begin):
		node._force_start.disconnect(task_begin)
func _toggle_force_stop(node : TaskNode, toggle : bool) -> void:
	if toggle:
		if !node._force_stop.is_connected(task_end):
			node._force_stop.connect(task_end, CONNECT_DEFERRED)
		return
	if node._force_stop.is_connected(task_end):
		node._force_stop.disconnect(task_end)
func _toggle_disable(node : TaskNode, toggle : bool) -> void:
	if toggle:
		if !node._disable_task.is_connected(task_disable):
			node._disable_task.connect(task_disable, CONNECT_DEFERRED)
		return
	if node._disable_task.is_connected(task_disable):
		node._disable_task.disconnect(task_disable)
func _toggle_process_update(node : TaskNode, toggle : bool) -> void:
	if toggle:
		if !node._update_process.is_connected(_update_process_mode):
			node._update_process.connect(_update_process_mode, CONNECT_DEFERRED)
		return
	if node._update_process.is_connected(_update_process_mode):
		node._update_process.disconnect(_update_process_mode)
#endregion


#region Private Methods (Helper)
func _auto_start_all() -> void:
	for state : TaskNode in _stored_tasks:
		if state.auto_start:
			task_begin(state.task_id(), state.auto_start_args)

func _update_proces_mode() -> void:
	set_process(!disabled && !_process_cache.is_empty())
	set_physics_process(!disabled && !_physics_cache.is_empty())
	set_process_unhandled_input(!disabled && !_input_cache.is_empty())
#endregion


#region Public Methods (Task)
func task_begin(
	node : TaskNode,
	given_args : Dictionary = {},
	overwrite : bool = false
) -> void:
	if !task_exists(node):
		return
	if is_task_running(node):
		if !overwrite:
			return
		task_end(node)
	
	_task_adjust_args(node, given_args)
	if !node.task_passthrough():
		return
	
	_toggle_force_start(node, false)
	_toggle_force_stop(node, true)
	_task_cache_add(node)
	
	node.task_begin()
	_update_proces_mode()
func task_end(
	node : TaskNode
) -> void:
	if !is_task_running(node):
		return
	
	_toggle_force_start(node, true)
	_toggle_force_stop(node, false)
	_task_cache_remove(node)
	
	node.task_end()
	_update_proces_mode()


func tap_state(
	node : TaskNode,
	given_args : Dictionary = {},
	overwrite : bool = false
) -> void:
	if !task_exists(node):
		return
	if is_task_running(node):
		if !overwrite:
			return
		task_end(node)
	
	_task_adjust_args(node, given_args)
	
	if !node.task_passthrough():
		return
	node.task_begin()
	node.task_end()

func task_disable(node : TaskNode, toggle : bool) -> void:
	if !task_exists(node):
		return
	
	node._disabled = toggle
	
	if toggle:
		_task_cache_remove(node)
		return
	_task_cache_add(node)
#endregion


#region Public Methods (Checks)
func is_task_running(node : TaskNode) -> bool:
	if !task_exists(node):
		return false
	return node._running
func task_exists(node : TaskNode) -> bool:
	return _stored_tasks.has(node)
#endregion
