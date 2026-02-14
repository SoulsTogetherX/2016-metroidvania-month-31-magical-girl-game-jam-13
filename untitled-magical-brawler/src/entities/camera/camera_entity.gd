@tool
extends BaseEntityManager


#region OnReady Variables
@export var target : BaseEntityManager:
	set(val):
		if val == target:
			return
		target = val
		
		if is_node_ready():
			_change_target()
#endregion


#region OnReady Variables
@onready var _task_manager: VelocityTaskManager = %TaskManager
#endregion



#region Virtual Methods
func _ready() -> void:
	_task_manager.task_begin(
		&"Velocity_Apply_Task",
		{ &"actor" : _actor }
	)
	
	_change_target()
#endregion


#region Private Methods
func _change_target() -> void:
	if !target:
		_task_manager.task_end(&"Lerp_To_Task")
		return
	_task_manager.task_begin(
		&"Lerp_To_Task",
		{
			&"actor" : _actor,
			&"get_target_pos" : target.predict_next_position
		},
		true
	)
#endregion


#region Public Methods (Actions)
func zoom_action(
	zoom : Vector2,
	duration : float = 0.2,
	ease_type : Tween.EaseType = Tween.EaseType.EASE_IN,
	transition_type : Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR,
	overwrite : bool = true
) -> void:
	_task_manager.task_begin(
		&"Zoom_Camera_Task",
		{
			"actor" : _actor,
			"zoom" : zoom,
			"duration" : duration,
			"ease_type" : ease_type,
			"transition_type" : transition_type
		},
		overwrite
	)


func shake_action(
	start_strength : Vector2,
	cutoff_strength : Vector2 = Vector2.ZERO,
	dampen_weight : Vector2 = Vector2.ZERO,
	dampen_flat : Vector2 = Vector2.ZERO,
	offset : Vector2 = Vector2.ZERO,
	overwrite : bool = true
) -> void:
	_task_manager.task_begin(
		&"Shake_Task",
		{
			"actor" : _actor,
			"start_strength" : start_strength,
			"cutoff_strength" : cutoff_strength,
			"dampen_weight" : dampen_weight,
			"dampen_flat" : dampen_flat,
			"offset" : offset
		},
		overwrite
	)
func stop_shake() -> void:
	_task_manager.task_end(&"Shake_Task")
#endregion
