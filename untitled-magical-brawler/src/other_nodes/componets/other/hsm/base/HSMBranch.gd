@abstract
class_name HSMBranch extends HSMBase


#region External Variables
signal _request_change(state : HSMBranch)
#endregion


#region External Variables
@export_group("Processing")
@export var need_process : bool
@export var need_physics : bool
@export var need_input : bool

@export_group("Context")
@export var need_action_start : bool
@export var need_action_finished : bool
@export var need_value_changed : bool
#endregion


#region Private Variables
var _running : bool

var _modules : Array[HSMModule]

var _context : HSMContext
var _actor : Node
#endregion



#region Virtual Methods
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			_get_modules()
#endregion


#region Private Methods (Modules)
func _get_modules() -> void:
	_modules.clear()
	for node : Node in get_children():
		if node is HSMModule:
			_modules.append(node)

func _start_modules() -> void:
	for module : HSMModule in _modules:
		module.start_module(_actor, _context)
func _end_modules() -> void:
	for module : HSMModule in _modules:
		module.end_module(_actor, _context)
#endregion


#region Public Process Methods
func process_frame(_delta : float) -> void:
	pass
func process_physics(_delta : float) -> void:
	pass
func process_input(_event: InputEvent) -> void:
	pass
#endregion


#region Public Context Methods
func action_started(_action_name : StringName) -> void:
	pass
func action_finished(_action_name : StringName) -> void:
	pass
func value_changed(_value_name : StringName) -> void:
	pass
#endregion


#region Public State Change Methods
func enter_state(_act : Node, _ctx : HSMContext) -> void:
	pass
func exit_state(_act : Node, _ctx : HSMContext) -> void:
	pass
func passthrough_state(_act : Node, _ctx : HSMContext) -> HSMBranch:
	return null

func change_state(state : HSMBranch) -> void:
	_request_change.emit(state)
#endregion


#region Public Methods (Access)
func is_running() -> bool:
	return _running

func get_context() -> HSMContext:
	return _context
func get_actor() -> Node:
	return _actor
#endregion
