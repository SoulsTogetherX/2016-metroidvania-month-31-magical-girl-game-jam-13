class_name StateMachine extends Node


#region External Variables
@export var starting_state : EmptyState
@export var actor : Node
#endregion


#region Private Variables
var _current_state : EmptyState = null
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
func _change_state(new_state: EmptyState) -> void:
	if _current_state:
		_current_state.exit()
		_current_state.force_change.disconnect(_change_state)

	var check_state : EmptyState = new_state
	while check_state:
		_current_state = check_state
		check_state = check_state.state_passthrough(actor)
	
	_current_state.force_change.connect(_change_state, CONNECT_DEFERRED)
	_current_state.enter(actor)
#endregion
