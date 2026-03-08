extends PathFollow2D


#region External Variables
@export var auto_start : bool = true

@export_group("Tween")
@export var duration : float = 1.0
@export var trans_type : Tween.TransitionType
@export var ease_type : Tween.EaseType
#endregion


#region Private Variables
var _path_tween : Tween
#endregion


#region OnReady Variables
@onready var _body: AnimatableBody2D = %AnimatableBody2D
#endregion



#region Virtual Methods
func _ready() -> void:
	reset()
#endregion


#region Private Methods
func _create_tween() -> void:
	if _path_tween:
		_path_tween.kill()
	_path_tween = create_tween()
	
	_path_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_path_tween.set_trans(trans_type)
	_path_tween.set_ease(ease_type)
	
	_path_tween.set_loops(-1)
	_path_tween.tween_method(
		_set_ratio, progress_ratio, progress_ratio + 1.0,
		duration
	)
	if !loop:
		_path_tween.tween_method(
			_set_ratio, progress_ratio + 1.0, progress_ratio,
			duration
		)
func _set_ratio(delta : float) -> void:
	_body.global_position = global_position
	progress_ratio = absf(1.0 - fmod(delta, 2.0))
#endregion


#region Public Methods
func reset() -> void:
	_create_tween()
	if !auto_start:
		_path_tween.pause()

func toggle_tween(toggle : bool = false) -> void:
	if !_path_tween:
		return
	if toggle:
		_path_tween.play()
		return
	_path_tween.pause()
#endregion
