extends TaskNode


#region External Variables
@export_group("Settings")
@export var ease_type : Tween.EaseType
@export var transition_type : Tween.TransitionType
@export var zoom : Vector2 = Vector2.ONE
@export_range(0.001, 1.0, 0.001, "or_greater") var duration : float = 0.2

@export_group("Other")
@export var actor : Camera2D
#endregion


#region Private Variables
var _zoom_tween : Tween
#endregion



#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	var act : Node2D = args.get(&"actor", actor)
	if !act:
		return false
	
	var ease_arg : Tween.EaseType = args.get(&"ease_type", ease_type)
	var trans_arg : Tween.TransitionType = args.get(&"transition_type", transition_type)
	var zoom_arg : Vector2 = args.get(&"zoom", zoom)
	var duration_arg : float = args.get(&"duration", duration)
	
	_zoom_tween = create_tween()
	_zoom_tween.set_ease(ease_arg)
	_zoom_tween.set_trans(trans_arg)
	_zoom_tween.tween_property(
		act,
		"zoom",
		zoom_arg,
		duration_arg
	)
	
	return true
func task_end(_args : Dictionary) -> void:
	_zoom_tween.kill()
	_zoom_tween = null
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Zoom_Camera_Task"
#endregion
