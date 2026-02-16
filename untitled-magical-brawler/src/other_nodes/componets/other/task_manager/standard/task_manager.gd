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
	_register_task()
	_auto_start_all()
	child_entered_tree.connect(_register_task.unbind(1))
	child_exiting_tree.connect(_register_task.unbind(1))

func _process(delta: float) -> void:
	for task : Task in _running_tasks.values():
		task.task_process(delta)
func _physics_process(delta: float) -> void:
	for task : Task in _running_tasks.values():
		task.task_physics(delta)
#endregion


#region Private Methods (Helper)
func _register_task() -> void:
	_stored_task.clear()
	
	for child : Node in get_children():
		if child is TaskNode:
			_stored_task[child.task_id()] = child
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
	
	var state : TaskNode = _stored_task.get(task_id)
	var task : Task = _create_task(state, given_args)
	if !task.task_begin():
		return
	
	task.force_stop.connect(task_end.bind(task_id))
	_running_tasks.set(task_id, task)
	
	_update_proces_mode()
func task_end(
	task_id : StringName
) -> void:
	if !is_state_running(task_id):
		return
	
	var task : Task = _running_tasks.get(task_id)
	task.task_end()
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
	
	var state : TaskNode = _stored_task.get(task_id)
	var total_args := get_args().merged(extra_args)
	
	if !state.task_begin(total_args):
		return
	state.task_end(total_args)
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
	var _state : TaskNode
	var _extra_args : Dictionary
	var _arg_cache : Dictionary
	
	var _get_base_args : Callable
	#endregion
	
	
	#region Virtual Methods
	func _init(
		managed_state : TaskNode,
		given_args : Dictionary,
		get_base_args : Callable
	) -> void:
		_extra_args  = given_args
		_state = managed_state
		_get_base_args = get_base_args
		
		_state.force_stop.connect(force_stop.emit)
		update_arg_cache()
	#endregion
	
	#region Public Virtual Methods
	func task_process(delta : float) -> bool:
		return _state.task_process(delta, _arg_cache)
	func task_physics(delta : float) -> bool:
		return _state.task_physics(delta, _arg_cache)
	#endregion

	#region Public Methods (Action States)
	func task_begin() -> bool:
		return _state.task_begin(_arg_cache)
	func task_end() -> void:
		_state.task_end(_arg_cache)
	#endregion

	#region Public Methods (Helper)
	func update_arg_cache() -> void:
		_arg_cache = (
			_get_base_args.call() as Dictionary
		).merged(_extra_args, true)
	#endregion
