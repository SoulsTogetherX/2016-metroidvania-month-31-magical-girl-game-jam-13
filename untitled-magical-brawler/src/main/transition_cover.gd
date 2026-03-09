class_name TransitionCover extends CanvasLayer


#region External Variables
@export_group("Settings")
@export var color := Color.BLACK
@export var init_state := true
#endregion


#region Private Variables
var _cover : ColorRect
var _transition_tween : Tween

var _expected_state : bool
#endregion



#region Virtual Methods
func _ready() -> void:
	_cover = ColorRect.new()
	_cover.color = color
	_cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_cover)
	_cover.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	_force_cover(init_state)
#endregion


#region Private Methods
func _kill_tween() -> void:
	if _transition_tween:
		_transition_tween.finished.emit()
		_transition_tween.kill()

func _toggle_cover(toggle : bool, duration : float) -> void:
	if _expected_state == toggle:
		return
	_kill_tween()
	
	_expected_state = toggle
	_transition_tween = create_tween()
	_transition_tween.set_ease(Tween.EASE_IN)
	_transition_tween.set_trans(Tween.TRANS_SINE)
	_transition_tween.tween_property(
		_cover, "modulate:a",
		float(_expected_state), duration
	)
	await _transition_tween.finished
func _force_cover(toggle : bool) -> void:
	_kill_tween()
	
	_expected_state = toggle
	_cover.modulate.a = float(_expected_state)
#endregion


#region Public Methods
func fade_cover(toggle : bool, duration : float = 0.5) -> void:
	await _toggle_cover(toggle, duration)
func force_cover(toggle : bool) -> void:
	_force_cover(toggle)
#endregion
