class_name HSMMaster extends HSMBase


#region External Variables
@export var starting_state : HSMBranch
@export var context : HSMContext:
	set = _set_context
@export var actor : Node
@export var disabled : bool:
	set(val):
		if val == disabled:
			return
		disabled = val
		_update_processing()
		_update_contexting()
#endregion


#region Private Variables
# Highest Node in the tree hierarchy
var _top : HSMBase
# Lowest Node in the tree hierarchy
var _bottom : HSMBase

var _process_queue : Array[HSMBranch]
var _physic_queue : Array[HSMBranch]
var _input_queue : Array[HSMBranch]

var _action_started_queue : Array[HSMBranch]
var _action_finished_queue : Array[HSMBranch]
var _value_changed_queue : Array[HSMBranch]
#endregion



#region Virtual Methods
func _ready() -> void:
	_top = self
	_bottom = self
	
	_propagate_parent(self)
	change_state(starting_state)
#endregion


#region Action Methods
func _process(delta: float) -> void:
	for state : HSMBranch in _process_queue:
		state.process_frame(delta)
func _physics_process(delta: float) -> void:
	for state : HSMBranch in _physic_queue:
		state.process_physics(delta)
func _unhandled_input(event: InputEvent) -> void:
	for state : HSMBranch in _input_queue:
		state.process_input(event)

func _action_started(action_name : StringName) -> void:
	for state : HSMBranch in _action_started_queue:
		state.action_started(action_name)
func _action_finished(action_name : StringName) -> void:
	for state : HSMBranch in _action_finished_queue:
		state.action_finished(action_name)
	
func _value_changed(value_name : StringName) -> void:
	for state : HSMBranch in _value_changed_queue:
		state.value_changed(value_name)
#endregion


#region Private Methods (Helper)
func _set_context(val : HSMContext) -> void:
	if val == context:
		return
	if val == null:
		val = HSMContext.new()
	if context != null:
		_set_action_started(false)
		_set_action_finished(false)
		_set_value_changed(false)
	
	context = val
	_update_contexting()


func _set_action_started(toggle : bool) -> void:
	if toggle:
		if !context.action_started.is_connected(_action_started):
			context.action_started.connect(_action_started)
		return
	if context.action_started.is_connected(_action_started):
		context.action_started.disconnect(_action_started)
func _set_action_finished(toggle : bool) -> void:
	if toggle:
		if !context.action_finished.is_connected(_action_finished):
			context.action_finished.connect(_action_finished)
		return
	if context.action_finished.is_connected(_action_finished):
		context.action_finished.disconnect(_action_finished)
func _set_value_changed(toggle : bool) -> void:
	if toggle:
		if !context.value_changed.is_connected(_value_changed):
			context.value_changed.connect(_value_changed)
		return
	if context.value_changed.is_connected(_value_changed):
		context.value_changed.disconnect(_value_changed)
func _set_request_change(state : HSMBranch, toggle : bool) -> void:
	if toggle:
		if !state._request_change.is_connected(change_state):
			state._request_change.connect(change_state, CONNECT_DEFERRED)
		return
	if state._request_change.is_connected(change_state):
		state._request_change.disconnect(change_state)


func _update_processing() -> void:
	set_process(!disabled && !_process_queue.is_empty())
	set_physics_process(!disabled && !_physic_queue.is_empty())
	set_process_unhandled_input(!disabled && !_input_queue.is_empty())
func _update_contexting() -> void:
	_set_action_started(!disabled && !_action_started_queue.is_empty())
	_set_action_finished(!disabled && !_action_finished_queue.is_empty())
	_set_value_changed(!disabled && !_value_changed_queue.is_empty())
#endregion


#region Private Methods (Clear Queue)
func _clear_queues() -> void:
	_process_queue.clear()
	_physic_queue.clear()
	_input_queue.clear()
	
	_action_started_queue.clear()
	_action_finished_queue.clear()
	_value_changed_queue.clear()
func _add_to_queue(state : HSMBranch) -> void:
	if state.need_process:
		_process_queue.append(state)
	if state.need_physics:
		_physic_queue.append(state)
	if state.need_input:
		_input_queue.append(state)
	
	if state.need_action_start:
		_action_started_queue.append(state)
	if state.need_action_finished:
		_action_finished_queue.append(state)
	if state.need_value_changed:
		_value_changed_queue.append(state)
#endregion


#region Private Methods (Propagates)
func _propagate_parent(bottom : HSMBase) -> void:
	for node : Node in bottom.get_children():
		if node is HSMBase:
			node._parent = bottom
			_propagate_parent(node)
func _propagate_child(new_state : HSMBase) -> void:
	var parent := new_state._parent
	while parent:
		if parent._child != new_state:
			_top = new_state._parent
		
		parent._child = new_state
		new_state = parent
		parent = new_state._parent


func _propagate_enter_state() -> void:
	if _top == null:
		return
		
	var top : HSMBranch = self._child
	# Adds needed to queue again
	while top && top != _top._child:
		_add_to_queue(top)
		top = top._child
	
	# Only acts on the changed states
	while top:
		top._running = true
		top._context = context
		top._actor = actor
		_add_to_queue(top)
		
		_set_request_change(top, true)
		top.enter_state(actor, context)
		top._start_modules()
		top = top._child
	
func _propagate_exit_state() -> void:
	var bottom : HSMBase = _bottom
	while bottom:
		if bottom == _top:
			return
		
		bottom._end_modules()
		bottom.exit_state(actor, context)
		_set_request_change(bottom, false)
		bottom._running = false
		bottom = bottom._parent
#endregion


#region Public Methods (Helper)
func change_state(new_state : HSMBranch) -> void:
	if disabled:
		return
	
	# Goes through passthrough
	var check_state : HSMBranch = new_state
	while check_state:
		new_state = check_state
		check_state = check_state.passthrough_state(actor, context)
			
		# If passthrough gives the same state, stop.
		# Avoids infinite loop.
		if _bottom == new_state && check_state != null:
			push_error("Possible Infinite State Loop Found")
			return
	if _bottom == new_state:
		return
	_propagate_child(new_state)
	
	_propagate_exit_state()
	_clear_queues()
	
	_bottom = new_state
	_propagate_enter_state()
	_action_finished_queue.reverse()
	
	_update_processing()
	_update_contexting()
#endregion
