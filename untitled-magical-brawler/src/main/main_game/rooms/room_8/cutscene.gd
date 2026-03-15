extends Cutscene


#endregion External Variables
@export_group("Cameras")
@export var camera_assign : AssignPlayer

@export_group("Other")
@export var cutscene_button : Node2D
@export var break_collide : TileMapLayer
@export var enemy : Enemy
#endregion


#endregion OnReady Variables
@onready var _ground_rumble: AudioStreamPlayer = $GroundRumble
@onready var _ground_brake: AudioStreamPlayer = $GroundBrake
#endregion



#endregion Private Methods
func _cutscene_skip() -> void:
	break_collide.enabled = false
	camera_assign.limit = null
	enemy.queue_free()
	cutscene_button.get_child(0).queue_free()
func _begin_cutscene() -> void:
	var control := Global.local_controller
	if control is RoomManager:
		control.play_music("")
	
	timer.start(1.0)
	await timer.timeout
	
	await _start_cam()
	cutscene_button.play_effect()
	_ground_rumble.play()
	
	if camera_start:
		await camera_start.tween_completed
	await _end_cam()
	
	await Global.transition_cover.fade_cover(
		true, 0.2
	)
	_ground_brake.play()
	Global.transition_cover.fade_cover(
		false, 0.2
	)
	
	break_collide.enabled = false
	_end_cutscene()
#endregion
