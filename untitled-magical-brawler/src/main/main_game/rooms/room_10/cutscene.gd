extends Cutscene


#endregion External Variables
@export_group("Other")
@export var break_collide : TileMapLayer
@export var cannons : Array[CannonEnemy]
#endregion



#endregion Private Methods
func _startup_cannons() -> void:
	for cannon : CannonEnemy in cannons:
		cannon.start()

func _cutscene_skip() -> void:
	break_collide.enabled = false
	_startup_cannons()

func _begin_cutscene() -> void:
	await _start_cam()
	await camera_start.tween_completed
	
	break_collide.enabled = false
	_startup_cannons()
	
	await _end_cam()
	_end_cutscene()
#endregion
