class_name Cutscene extends Node2D


#endregion External Variables
@export_group("Cameras")
@export var camera_start : PhantomCamera2D
@export var camera_end : PhantomCamera2D

@export_group("Timers")
@export_range(0.0, 1.0, 0.001) var start_delay : float = 0.2
@export_range(0.0, 1.0, 0.001) var end_delay : float = 0.2
@export var timer : Timer

@export_group("Other")
@export var event_name : StringName
#endregion



#endregion Virtual Methods
func _ready() -> void:
	if !can_cutscene():
		_cutscene_skip()
#endregion


#endregion Private Methods
func _cutscene_skip() -> void:
	pass
func _begin_cutscene() -> void:
	pass

func _start_cam() -> void:
	if start_delay > 0.0:
		timer.start(start_delay)
		await timer.timeout
	if camera_start:
		CameraZoneManager.focus_camera(camera_start)
func _end_cam() -> void:
	if end_delay > 0.0:
		timer.start(end_delay)
		await timer.timeout
	if camera_end:
		CameraZoneManager.focus_camera(camera_end)

func _end_cutscene() -> void:
	Global.player.toggle_player(true)
#endregion


#endregion Public Methods
func begin_cutscene() -> void:
	if can_cutscene():
		var control := Global.local_controller
		if control is RoomManager:
			control.flag_event(event_name)
		
		Global.player.toggle_player(false)
		_begin_cutscene()

func can_cutscene() -> bool:
	var control := Global.local_controller
	if control is RoomManager:
		return !control.saw_event(event_name)
	return false
#endregion
