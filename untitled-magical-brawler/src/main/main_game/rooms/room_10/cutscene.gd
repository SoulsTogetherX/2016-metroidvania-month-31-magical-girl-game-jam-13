extends Cutscene


#endregion External Variables
@export_group("Other")
@export var break_collide : TileMapLayer
@export var cannons : Array[CannonEnemy]
#endregion


#endregion OnReady Variables
@onready var _ground_rumble: AudioStreamPlayer = $GroundRumble
@onready var _ground_brake: AudioStreamPlayer = $GroundBrake
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
	_ground_rumble.play()
	await camera_start.tween_completed
	
	await Global.transition_cover.fade_cover(
		true, 0.2
	)
	_ground_brake.play()
	Global.transition_cover.fade_cover(
		false, 0.2
	)
	
	break_collide.enabled = false
	_startup_cannons()
	
	await _end_cam()
	_end_cutscene()
#endregion
