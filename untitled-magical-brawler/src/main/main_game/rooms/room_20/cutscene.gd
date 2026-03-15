extends Cutscene


#region OnReady Variables
@onready var _finish_jingle: AudioStreamPlayer = $GameFinishJingle
@onready var _win_display: CanvasLayer = $WinDisplay
#endregion



#region Virtual Methods
func _ready() -> void:
	_win_display.visible = false
#endregion


#region Private Methods
func _begin_cutscene() -> void:
	var controler := Global.local_controller
	
#region Start
	# Scroll Camera
	await _start_cam()
	await camera_start.tween_completed
	
	if controler is RoomManager:
		controler.clear_music()
	
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
	
#region Win Display
	_finish_jingle.play()
	_win_display.visible = true
	
	timer.start(0.2)
	await timer.timeout
#endregion
	
#region Double Take
	Global.player.change_direction(false)
	timer.start(0.3)
	await timer.timeout
	Global.player.change_direction(true)
	timer.start(0.5)
	await timer.timeout
	Global.player.change_direction(false)
#endregion
	
#region Delay
	timer.start(1.0)
	await timer.timeout
#endregion
	
#region Double Double Take
	Global.player.change_direction(false)
	timer.start(0.2)
	await timer.timeout
	Global.player.change_direction(true)
	timer.start(0.2)
	await timer.timeout
	Global.player.change_direction(false)
#endregion
	
#region Acceptance
	timer.start(5.0)
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
#endregion
