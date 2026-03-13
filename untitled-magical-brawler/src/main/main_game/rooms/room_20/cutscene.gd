extends Cutscene



func _begin_cutscene() -> void:
#region Start
	# Scroll Camera
	await _start_cam()
	await camera_start.tween_completed
	# Scroll Camera
	await _end_cam()
	await camera_end.tween_completed
	
	# Wait
	timer.start(2.0)
	await timer.timeout
#endregion
	
#region Awkard Look Around
	Global.player.change_direction(false)
	timer.start(0.7)
	await timer.timeout
	Global.player.change_direction(true)
	timer.start(0.7)
	await timer.timeout
	Global.player.change_direction(false)
#endregion
	
#region Slow Realization
	timer.start(3.0)
	await timer.timeout
#endregion
	
#region Double Take
	Global.player.change_direction(false)
	timer.start(0.2)
	await timer.timeout
	Global.player.change_direction(true)
	timer.start(0.2)
	await timer.timeout
	Global.player.change_direction(false)
#endregion
	
#region Acceptance
	timer.start(2.0)
	await timer.timeout
#endregion
	
#region Walk Away
	Global.player.force_move(-1.0)
	
	timer.start(1.0)
	await timer.timeout
#endregion
	
#region Black End
	Global.transition_cover.force_cover(true)
	Global.player.force_move(0.0)
#endregion
	
#region Player Realization
	timer.start(3.0)
	await timer.timeout
	
	Global.main_controller.load_main_menu()
#endregion
