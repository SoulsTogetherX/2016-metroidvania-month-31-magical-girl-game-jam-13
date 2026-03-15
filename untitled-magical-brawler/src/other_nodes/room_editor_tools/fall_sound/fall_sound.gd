extends Node2D


#region OnReady Variables
@onready var _start_fall: Area2D = %StartFall

@onready var _falling_sound: AudioStreamPlayer = %FallingSound
@onready var _impact_sound: AudioStreamPlayer = %ImpactSound
#endregion



#region Virtual Methods
func _ready() -> void:
	_start_fall.monitoring = false
	_start_fall.monitorable = false
	
	_start_fall.collision_layer = 0
	_start_fall.collision_mask = Constants.COLLISION.PLAYER
	
	if Engine.is_editor_hint():
		return
	
	_start_fall.body_entered.connect(_on_fall_start.unbind(1))
	_after_ready()

func _after_ready() -> void:
	_start_fall.monitoring = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	_start_fall.monitoring = true
#endregion


#region Private Methods
func _on_fall_start() -> void:
	_falling_sound.play(3.11)
	_start_fall_checks()

func _start_fall_checks() -> void:
	if is_inside_tree() && !get_tree().process_frame.is_connected(_on_fall_check):
		get_tree().process_frame.connect(_on_fall_check)
func _end_fall_checks() -> void:
	if is_inside_tree() && get_tree().process_frame.is_connected(_on_fall_check):
		get_tree().process_frame.disconnect(_on_fall_check)
func _on_fall_check() -> void:
	if !Global.player.is_on_floor():
		return
	_end_fall_checks()
	
	var control := Global.local_controller
	if control is RoomManager:
		control.play_music((owner as Room).music)
	
	
	Global.camera.screen_shake(
		GlobalCamera.create_noise(
			100, 500
		),
		1.0, 0.0, 1.0
	)
	_falling_sound.stop()
	_impact_sound.play()
#endregion
