extends TaskNode


#region External Variables
@export_group("Settings")
@export var flash_color : Color = Color.WHITE

@export_group("Other")
@export var actor : Node2D
#endregion


#region Private Variables
var _old_modulate : Color
#endregion



#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	var act : Node2D = get_argument(args, &"actor", actor)
	if act == null:
		return false
	
	_old_modulate = act.modulate
	act.modulate = get_argument(args, &"color", flash_color)
	
	return true
func task_end(args : Dictionary) -> void:
	var act : Node2D = get_argument(args, &"actor", actor)
	act.modulate = _old_modulate
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Flash_Task"
#endregion
