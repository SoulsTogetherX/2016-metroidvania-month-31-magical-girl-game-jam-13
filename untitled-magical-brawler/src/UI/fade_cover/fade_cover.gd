@tool
class_name FadeCoverNode extends ColorRect


#region External Variables
@export var toggle : bool:
	set = toggle_fade,
	get = get_fade
@export var ease_type : Tween.EaseType
@export var transition_type : Tween.TransitionType
@export_range(0.0, 1.0, 0.001, "or_greater") var duration : float = 0.2
#endregion


#region Private Variables
var _toggle : bool
var _fade_tween : Tween
#endregion



#region Private Methods
func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	force_fade(_toggle)
	color = Color.BLACK
func _kill_tween() -> void:
	if _fade_tween:
		_fade_tween.kill()
#endregion


#region Public Methods
func get_fade() -> bool:
	return _toggle
func toggle_fade(val : bool) -> void:
	if Engine.is_editor_hint():
		force_fade(val)
		return
	if !is_node_ready() || val == toggle:
		return
	_kill_tween()
	
	_toggle = val
	_fade_tween = create_tween()
	_fade_tween.set_ease(ease_type)
	_fade_tween.set_trans(transition_type)
	_fade_tween.tween_property(
		self,
		"modulate:a",
		float(val),
		duration
	)
	await _fade_tween.finished

func force_fade(val : bool) -> void:
	_kill_tween()
	_toggle = val
	modulate.a = float(val)
#endregion
