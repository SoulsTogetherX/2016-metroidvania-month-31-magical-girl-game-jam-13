class_name StateMachine extends Node


#region Signals
signal changed_state
signal cleared_state
#endregion


#region External Variables
@export_group("Settings")
@export var disabled : bool:
	set(val):
		if val == disabled:
			return
		disabled = val
		
		if _current_state:
			_current_state._disable_state(disabled)
		
		if disabled:
			_disable_processes()
			return
		_sync_processing_to_state(_current_state)

@export_group("States")
@export var starting_state : StateNode
#endregion


#region Private Variables
var _current_state : StateNode = null
#endregion



#region Virtual Methods
func _ready() -> void:
	_change_state(starting_state)

func _process(delta: float) -> void:
	var new_state := _current_state.process_frame(delta)
	if new_state:
		_change_state(new_state)
func _physics_process(delta: float) -> void:
	var new_state := _current_state.process_physics(delta)
	if new_state:
		_change_state(new_state)
func _unhandled_input(input: InputEvent) -> void:
	var new_state := _current_state.process_input(input)
	if new_state:
		_change_state(new_state)
#endregion


#region Private Methods (Helper)
func _change_state(new_state: StateNode, passthrough : bool = true) -> void:
	# Not allowed to change states if disabled
	if disabled:
		return
	
	# Not allowed to reenter same state
	if _current_state == new_state:
		return
	
	# If current state exists, start exit process
	if _current_state != null:
		_current_state._exit_state()
		_disable_processes()
		_current_state._force_change.disconnect(_change_state)
		_current_state._running = false
	
	# If changing to null, clear it
	if new_state == null:
		clear_state()
		return
	
	# Goes through passthrough
	var check_state : StateNode = new_state
	if passthrough:
		if new_state:
			while new_state:
				check_state = new_state
				new_state = new_state._state_passthrough()
				
				# If passthrough gives the same state, stop.
				# Avoids infinite loop.
				if _current_state == check_state && new_state != null:
					push_error("Possible Infinite State Loop Found")
					return
	
	_current_state = check_state
	
	# If current state exists, start enter process
	_current_state._force_change.connect(_change_state, CONNECT_DEFERRED)
	_current_state._running = true
	_current_state._enter_state()
	
	# Begins processes if not disabled
	if !disabled:
		_sync_processing_to_state(_current_state)
	
	changed_state.emit()
func _sync_processing_to_state(state: StateNode) -> void:
	if state == null:
		_disable_processes()
		return
	set_process(state.need_process)
	set_physics_process(state.need_physics)
	set_process_unhandled_input(state.need_input)

func _disable_processes() -> void:
	set_process(false)
	set_process_unhandled_input(false)
	set_physics_process(false)
#endregion


#region Public Methods (Helper)
func force_state(new_state: StateNode, passthrough : bool = true) -> void:
	_change_state(new_state, passthrough)

func clear_state() -> void:
	_current_state = null
	_disable_processes()
	cleared_state.emit()
#endregion
