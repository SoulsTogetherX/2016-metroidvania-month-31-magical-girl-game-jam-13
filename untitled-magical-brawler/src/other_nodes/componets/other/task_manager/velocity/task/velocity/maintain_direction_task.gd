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
@export var sprite : AnimatedSprite2D
#endregion



#region Public Virtual Methods
func task_physics(_delta : float, args : Dictionary) -> bool:
	var spr : AnimatedSprite2D = get_argument(
		args, &"sprite", sprite
	)
	spr.flip_h = get_argument(args, &"flip_h", flip_h)
	spr.flip_v = get_argument(args, &"flip_v", flip_v)
	
	return true
#endregion


#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if !(get_argument(args, &"sprite", sprite) is AnimatedSprite2D):
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Maintain_Direction_Task"
#endregion
