class_name StateMachine extends Node


#region External Variables
@export_group("Settings")
@export var disabled : bool:
	set(val):
		if val == disabled:
			return
		disabled = val
		_toggle_processes(!disabled)

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
func _change_state(new_state: StateNode) -> void:
	if _current_state:
		_current_state._exit_state()
		_current_state._force_change.disconnect(_change_state)
		_current_state._running = false
	
	if !new_state:
		clear_state()
		return
	
	var check_state : StateNode = new_state
	while check_state:
		_current_state = check_state
		check_state = check_state.state_passthrough()
	
	_current_state._force_change.connect(_change_state, CONNECT_DEFERRED)
	_current_state._running = true
	_current_state._enter_state()

func _toggle_processes(toggle : bool) -> void:
	if disabled:
		return
	
	set_process(toggle)
	set_process_unhandled_input(toggle)
	set_physics_process(toggle)
#endregion


#region Public Methods (Helper)
func force_state(new_state: StateNode) -> void:
	_change_state(new_state)
func clear_state() -> void:
	_current_state = null
	_toggle_processes(false)
#endregion
