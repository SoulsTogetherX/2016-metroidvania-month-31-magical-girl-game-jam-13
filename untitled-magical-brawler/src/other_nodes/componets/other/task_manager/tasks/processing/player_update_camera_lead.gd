extends TaskNode


#region External Variables
@export_group("Modules")
@export var context : HSMContext

@export_group("Other")
@export var actor : CameraLead
#endregion


#region Private Variables
var _context : HSMContext

var _actor : CameraLead
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Action Methods
func action_changed(action_name : String, _val : bool) -> void:
	var labels := GlobalLabels.hsm_context
	
	match action_name:
		labels.ACT_PLAYER_LEFT, labels.ACT_PLAYER_RIGHT:
			_actor.direction.x = (int(
				_context.is_action(labels.ACT_PLAYER_RIGHT)
			) - int(
				_context.is_action(labels.ACT_PLAYER_LEFT)
			))
		labels.ACT_PLAYER_UP, labels.ACT_PLAYER_DOWN:
			_actor.direction.y = (int(
				_context.is_action(labels.ACT_PLAYER_DOWN)
			) - int(
				_context.is_action(labels.ACT_PLAYER_UP)
			))
#endregion


#region Public Methods (Action States)
func task_passthrough() -> bool:
	_actor = args.get(&"actor", actor)
	if _actor == null:
		return false
	
	_context = args.get(&"context", context)
	if _context == null:
		return false
	
	return true

func task_begin() -> void:
	_context.action_changed.connect(action_changed)
func task_end() -> void:
	_context.action_changed.disconnect(action_changed)
#endregion
