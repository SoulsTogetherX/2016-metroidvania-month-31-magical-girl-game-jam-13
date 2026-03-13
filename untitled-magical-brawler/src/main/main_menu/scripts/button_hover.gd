@tool
extends AnimatableControl


#region External Variables
@export_group("Audio")
@export var sound_effect : AudioStreamPlayer

@export_group("Scaling")
@export var max_scale := Vector2(1.1, 1.1)
@export var min_scale := Vector2(1.0, 1.0)

@export_group("Tweening")
@export var trans_type : Tween.TransitionType = Tween.TRANS_SINE
@export var ease_type : Tween.EaseType = Tween.EASE_IN_OUT
@export_range(
	0.0, 5.0, 0.001, "or_greater"
) var duration : float = 0.2
#endregion


#region Private Variables
var _current_scale : bool = false

var _tween : Tween
#endregion



#region Virtual Methods
func _ready() -> void:
	_force_scale(_current_scale)
	
	if !Engine.is_editor_hint():
		var control : Control = get_child(0)
		control.mouse_entered.connect(start_hover)
		control.mouse_exited.connect(end_hover)

func _validate_property(property : Dictionary) -> void:
	if property.name in [&"max_scale", &"min_scale"]:
		property.hint |= PROPERTY_HINT_LINK
#endregion


#region Private Methods
func _kill_tween() -> void:
	if _tween:
		_tween.kill()
func _tween_scale(toggle : bool) -> void:
	_kill_tween()
	
	_tween = create_tween()
	_tween.set_trans(trans_type)
	_tween.set_ease(ease_type)
	_tween.tween_property(
		self, "scale", max_scale if toggle else min_scale,
		duration
	)
func _force_scale(toggle : bool) -> void:
	_kill_tween()
	scale = max_scale if toggle else min_scale

func _reset_scale() -> void:
	if _current_scale:
		start_hover()
		return
	end_hover()
#endregion


#region Public Methods
func start_hover() -> void:
	_current_scale = true
	if sound_effect:
		sound_effect.play()
	
	_tween_scale(true)
func end_hover() -> void:
	_current_scale = false
	_tween_scale(false)
#endregion
