class_name StateManager extends Node


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
var _stored_states : Dictionary[StringName, ManagedState]

var _running : bool = false
#endregion



#region Virtual Methods
func _ready() -> void:
	_register_states()
	_auto_start_all()
	child_entered_tree.connect(_register_states)
	child_exiting_tree.connect(_register_states)

func _process(delta: float) -> void:
	for task : Task in _running_tasks.values():
		task.state_process(delta)
func _physics_process(delta: float) -> void:
	for task : Task in _running_tasks.values():
		task.state_physics(delta)
#endregion


#region Private Methods (Helper)
func _register_states() -> void:
	_stored_states.clear()
	
	for child : Node in get_children():
		if child is ManagedState:
			_stored_states[child.state_id()] = child
func _auto_start_all() -> void:
	for state : ManagedState in _stored_states.values():
		prints(state.state_id(), state.auto_start)
		if state.auto_start:
			begin_task(state.state_id(), state.auto_start_args)

func _update_proces_mode() -> void:
	var running := !disabled && !_running_tasks.is_empty()
	if running == _running:
		return
	
	set_process(running)
	set_physics_process(running)
#endregion


#region Public Methods (Task)
func begin_task(
	state_id : StringName,
	given_args : Dictionary = {},
	overwrite : bool = false
) -> void:
	if !state_exists(state_id):
		return
	if is_state_running(state_id):
		if !overwrite:
			return
		end_task(state_id)
	
	var state : ManagedState = _stored_states.get(state_id)
	var task : Task = Task.new(state, get_args, given_args)
	if !task.begin_state():
		return
	
	task.force_stop.connect(end_task.bind(state_id))
	_running_tasks.set(state_id, task)
	
	_update_proces_mode()
func end_task(
	state_id : StringName
) -> void:
	if !is_state_running(state_id):
		return
	
	var task : Task = _running_tasks.get(state_id)
	task.end_state()
	_running_tasks.erase(state_id)
	
	_update_proces_mode()


func tap_state(
	state_id : StringName,
	extra_args : Dictionary = {},
	overwrite : bool = false
) -> void:
	if !state_exists(state_id):
		return
	if is_state_running(state_id):
		if !overwrite:
			return
		end_task(state_id)
	
	var state : ManagedState = _stored_states.get(state_id)
	var total_args := get_args().merged(extra_args)
	
	if !state.begin_state(total_args):
		return
	state.end_state(total_args)
#endregion


#region Public Methods (Checks)
func is_state_running(state_id : StringName) -> bool:
	return _running_tasks.has(state_id)
func state_exists(state_id : StringName) -> bool:
	return _stored_states.has(state_id)
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
	var _state : ManagedState
	var _extra_args : Dictionary
	var _arg_cache : Dictionary
	
	var _get_base_args : Callable
	#endregion
	
	
	#region Virtual Methods
	func _init(
		managed_state : ManagedState,
		get_base_args : Callable,
		given_args : Dictionary
	) -> void:
		_extra_args  = given_args
		_get_base_args = get_base_args
		_state = managed_state
		
		_state.force_stop.connect(force_stop.emit)
		update_arg_cache()
	#endregion
	
	#region Public Virtual Methods
	func state_process(delta : float) -> bool:
		return _state.state_process(delta, _arg_cache)
	func state_physics(delta : float) -> bool:
		return _state.state_physics(delta, _arg_cache)
	#endregion

	#region Public Methods (Action States)
	func begin_state() -> bool:
		return _state.begin_state(_arg_cache)
	func end_state() -> void:
		_state.end_state(_arg_cache)
	#endregion

	#region Public Methods (Helper)
	func update_arg_cache() -> void:
		_arg_cache = (
			_get_base_args.call() as Dictionary
		).merged(_extra_args, true)
	#endregion
