extends TaskNode


#region External Variables
@export_group("Modules")
@export var context : HSMContext

@export_group("Other")
@export var actor : Enemy
@export_range(0.0, 1000.0, 0.001, "or_greater") var forgiveness : float = 100.0
#endregion


#region Private Variables
var _context : HSMContext

var _actor : Enemy
#endregion



#region Virtual Methods
func _ready() -> void:
	need_physics = true
#endregion


#region Public Virtual Methods
func task_physics(_delta : float) -> void:
	_context.set_action(
		GlobalLabels.hsm_context.ACT_MOVING,
		absf(
			_actor.get_target_point.call().x - _actor.global_position.x
		) > forgiveness
	)
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
#endregion
