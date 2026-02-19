extends TaskNode


#region Enums
enum AXIS {
	X = 1,
	Y = 2
}
#endregion


#region External Variables
@export_group("Settings")
@export var flip_h : bool
@export var flip_v : bool

@export_group("Other")
@export var actor : Node2D
#endregion



#region Public Virtual Methods
func task_process(_delta : float, args : Dictionary) -> bool:
	var act : Node2D = get_argument(args, &"actor", actor)
	var h_flip : bool = get_argument(args, &"flip_h", flip_h)
	var v_flip : bool = get_argument(args, &"flip_v", flip_v)
	
	if actor is BaseEntity:
		actor.change_direction(h_flip, v_flip)
		return true
	
	act.scale = Vector2(
		-1.0 if h_flip else 1.0,
		-1.0 if v_flip else 1.0
	)
	return true
#endregion


#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if !(get_argument(args, &"actor", actor) is Node2D):
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Maintain_Direction_Task"
#endregion
