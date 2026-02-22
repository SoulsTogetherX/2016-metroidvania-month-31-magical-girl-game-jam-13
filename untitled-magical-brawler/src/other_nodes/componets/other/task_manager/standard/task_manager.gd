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
var _running_cache : Array[TaskNode]

var _running_tasks : Dictionary[StringName, TaskNode]
var _stored_task : Dictionary[StringName, TaskNode]
#endregion



#region Virtual Methods
func _ready() -> void:
	_register_task_nodes()
	_auto_start_all()
	child_entered_tree.connect(_register_task_node)
	child_exiting_tree.connect(_unregister_task_node)

func _process(delta: float) -> void:
	for task : TaskNode in _running_cache:
		task.task_process(delta)
func _physics_process(delta: float) -> void:
	for task : TaskNode in _running_cache:
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
			_stored_task[node.task_id()] = node
			_toggle_force_start(node, true)
			_toggle_disable(node, true)
func _unregister_task_nodes() -> void:
	for node : TaskNode in _stored_task.values():
		_stored_task[node.task_id()] = node
		
		_toggle_force_start(node, false)
		_toggle_force_stop(node, false)
		_toggle_disable(node, false)
	
	_stored_task.clear()
	_task_cache_clear()

func _register_task_node(node : Node) -> void:
	if node is TaskNode:
		if _stored_task.has(node.task_id()):
			return
		
		_stored_task.set(node.task_id(), node)
		node._force_start.connect(task_begin)
		_toggle_force_start(node, true)
		_toggle_disable(node, true)
func _unregister_task_node(node : Node) -> void:
	if node is TaskNode:
		if !_stored_task.has(node.task_id()):
			return
	
		_stored_task.erase(node.task_id())
		_task_cache_remove(node)
		
		_toggle_force_start(node, false)
		_toggle_force_stop(node, false)
		_toggle_disable(node, false)
#endregion


#region Private Methods (Task Cache)
func _task_adjust_args(node : TaskNode, args : Dictionary) -> void:
	node.args = args

func _task_cache_clear() -> void:
	_running_tasks.clear()
	_physics_cache.clear()
	_process_cache.clear()
	_input_cache.clear()
	_running_cache.clear()

func _task_cache_add(node : TaskNode) -> void:
	if node.is_disabled():
		return
	
	_running_tasks.set(node.task_id(), node)
	
	if node.need_physics:
		_physics_cache.append(node)
	if node.need_process:
		_process_cache.append(node)
	if node.need_input:
		_input_cache.append(node)
	_running_cache.append(node)
func _task_cache_remove(node : TaskNode) -> void:
	_running_tasks.erase(node.task_id())
	
	_physics_cache.erase(node)
	_process_cache.erase(node)
	_input_cache.erase(node)
	_running_cache.erase(node)

func _toggle_force_start(node : TaskNode, toggle : bool) -> void:
	if toggle:
		if node._force_start.is_connected(task_begin):
			node._force_start.disconnect(task_begin)
		return
	if !node._force_start.is_connected(task_begin):
		node._force_start.connect(task_begin)
func _toggle_force_stop(node : TaskNode, toggle : bool) -> void:
	if toggle:
		if node._force_stop.is_connected(task_end):
			node._force_stop.disconnect(task_end)
		return
	if !node._force_stop.is_connected(task_end):
		node._force_stop.connect(task_end)
func _toggle_disable(node : TaskNode, toggle : bool) -> void:
	if toggle:
		if node._disable_task.is_connected(task_disable):
			node._disable_task.disconnect(task_disable)
		return
	if !node._disable_task.is_connected(task_disable):
		node._disable_task.connect(task_disable)
#endregion


#region Private Methods (Helper)
func _auto_start_all() -> void:
	for state : TaskNode in _stored_task.values():
		if state.auto_start:
			task_begin(state.task_id(), state.auto_start_args)

func _update_proces_mode() -> void:
	set_process(!disabled && !_process_cache.is_empty())
	set_physics_process(!disabled && !_physics_cache.is_empty())
	set_process_unhandled_input(!disabled && !_input_cache.is_empty())
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
	_task_adjust_args(node, given_args)
	if !node.task_passthrough():
		return
	
	node._running = true
	_toggle_force_start(node, false)
	_toggle_force_stop(node, true)
	
	node.task_begin()
	_task_cache_add(node)
	
	_update_proces_mode()
func task_end(
	task_id : StringName
) -> void:
	if !is_state_running(task_id):
		return
	
	var node : TaskNode = _stored_task.get(task_id)
	node._running = false
	_toggle_force_start(node, true)
	_toggle_force_stop(node, false)
	
	node.task_end()
	
	_task_cache_remove(node)
	_update_proces_mode()


func tap_state(
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
	_task_adjust_args(node, given_args)
	
	if !node.task_passthrough():
		return
	node.task_begin()
	node.task_end()

func task_disable(task_id : StringName, toggle : bool) -> void:
	if !state_exists(task_id):
		return
	
	var node : TaskNode = _stored_task.get(task_id)
	node.disabled = toggle
	
	if toggle:
		_task_cache_remove(node)
		return
	_task_cache_add(node)
#endregion


#region Public Methods (Checks)
func is_state_running(task_id : StringName) -> bool:
	return _running_tasks.has(task_id)
func state_exists(task_id : StringName) -> bool:
	return _stored_task.has(task_id)
#endregion
