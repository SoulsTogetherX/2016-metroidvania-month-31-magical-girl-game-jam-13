@tool
extends MaxSizeContainer


#region Private Variables
var _fade_tween : Tween
#endregion



#region Virtual Methods
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_force_fade(is_paused())
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		set_paused(!is_paused())
#endregion


#region Private Methods (Fade Helper)
func _create_fade_tween(paused : bool) -> void:
	if _fade_tween:
		_fade_tween.kill()
		
	_fade_tween = create_tween()
	_fade_tween.tween_property(
		self,
		"modulate:a",
		int(paused),
		0.2
	)
func _force_fade(paused : bool) -> void:
	modulate.a = int(paused)
#endregion


#region Private Methods (On Button Press)
func _on_resume_game_btn_pressed() -> void:
	set_paused(false)

func _on_main_menu_btn_pressed() -> void:
	pass

func _on_quit_game_btn_pressed() -> void:
	get_tree().quit()
#endregion


#region Public Methods (Helper)
func set_paused(pause : bool) -> void:
	if !get_tree() || get_tree().paused == pause:
		return
	
	get_tree().paused = pause
	_create_fade_tween(pause)

func is_paused() -> bool:
	if !get_tree():
		return false
	
	return get_tree().paused
#endregion
