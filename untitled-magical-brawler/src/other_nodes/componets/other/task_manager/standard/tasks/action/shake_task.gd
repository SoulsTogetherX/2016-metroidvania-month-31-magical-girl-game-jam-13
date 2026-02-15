extends TaskNode


#region External Variables
@export_group("Settings")
@export_subgroup("Base")
@export var start_strength : Vector2
@export var cutoff_strength : Vector2

@export_subgroup("Damping")
@export var dampen_weight : Vector2
@export var dampen_flat : Vector2


@export_group("Other")
@export var actor : Camera2D
#endregion


#region Private Variables
var _current_strength : Vector2
#endregion



#region Public Virtual Methods
func task_process(delta : float, args : Dictionary) -> bool:
	var cutoff : Vector2 = get_argument(
		args, &"cutoff_strength", cutoff_strength
	)
	var weight : Vector2 = get_argument(
		args, &"dampen_weight", dampen_weight
	)
	var flat : Vector2 = get_argument(
		args, &"flat", dampen_flat
	)
	
	actor.offset = Vector2(
		randf_range(cutoff.x, _current_strength.x),
		randf_range(cutoff.y, _current_strength.y)
	)
	
	_current_strength = Utilities.dampv(
		(_current_strength - flat),
		Vector2.ZERO,
		weight,
		delta
	).max(cutoff)
	
	return (
		_current_strength.x <= cutoff.x &&
		_current_strength.y <= cutoff.y
	)
#endregion


#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if !(get_argument(args, &"actor", actor) is Node2D):
		return false
	
	_current_strength = get_argument(
		args, &"start_strength", start_strength
	)
	return true
func task_end(_args : Dictionary) -> void:
	actor.position = Vector2.ZERO
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Shake_Task"
#endregion
