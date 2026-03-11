extends Cutscene


#endregion External Variables
@export_group("Cameras")
@export var camera_assign : AssignPlayer

@export_group("Other")
@export var break_collide : TileMapLayer
@export var enemy : Enemy
#endregion



#endregion Private Methods
func _cutscene_skip() -> void:
	break_collide.enabled = false
	camera_assign.limit = null
	enemy.queue_free()
func _begin_cutscene() -> void:
	await _start_cam()
	if camera_start:
		await camera_start.tween_completed
	
	break_collide.enabled = false
	_end_cutscene()
#endregion
