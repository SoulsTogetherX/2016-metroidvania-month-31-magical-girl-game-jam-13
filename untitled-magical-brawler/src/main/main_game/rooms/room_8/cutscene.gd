extends Cutscene


#endregion External Variables
@export_group("Cameras")
@export var camera_assign : AssignPlayer

@export_group("Other")
@export var cutscene_button : Node2D
@export var break_collide : TileMapLayer
@export var enemy : Enemy
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
	if camera_start:
		await camera_start.tween_completed
	await _end_cam()
	
	break_collide.enabled = false
	_end_cutscene()
#endregion
