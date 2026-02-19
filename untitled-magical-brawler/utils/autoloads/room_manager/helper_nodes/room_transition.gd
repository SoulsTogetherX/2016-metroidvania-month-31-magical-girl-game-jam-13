class_name RoomTransitionNode extends ColorRect


var _transition_tween : Tween



func _ready() -> void:
	# Doesn't matter because still waiting on UI
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	modulate.a = 1.0
	



func goto_scene(node : Node) -> void:
	#await _start_transition()
	get_tree().change_scene_to_node.call_deferred(node)
	#await _end_transition()


func _start_transition() -> void:
	if _transition_tween:
		_transition_tween.kill()
	
	_transition_tween = create_tween()
	_transition_tween.tween_property(
		self,
		"modulate:a",
		0.0,
		1.0
	)
	await _transition_tween.finished
func _end_transition() -> void:
	if _transition_tween:
		_transition_tween.kill()
	
	_transition_tween = create_tween()
	_transition_tween.tween_property(
		self,
		"modulate:a",
		1.0,
		0.0
	)
	await _transition_tween.finished
