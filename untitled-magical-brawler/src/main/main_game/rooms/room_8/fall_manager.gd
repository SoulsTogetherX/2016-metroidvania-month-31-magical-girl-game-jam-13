extends Node2D


#region External Variables
@export_file_path("*.ogg") var music_path : String = "res://assets/music/2. Magic Mushroom Shards.ogg"
#endregion


#region Private Variables
var _is_falling : bool = false
#endregion


#region Onready Variables
@onready var _noise_emitter: PhantomCameraNoiseEmitter2D = %NoiseEmitter2D

@onready var _fall_check: Area2D = %FallCheck
@onready var _land_check: Area2D = %LandCheck
#endregion



#region Virtual Methods
func _ready() -> void:
	_fall_check.body_entered.connect(_is_fall_flag.unbind(1))
	_land_check.body_entered.connect(_on_land.unbind(1))
#endregion


#region Private Methods
func _is_fall_flag() -> void:
	_is_falling = true
func _on_land() -> void:
	if !_is_falling:
		return
	_is_falling = false
	
	var control := Global.local_controller
	if control is RoomManager:
		control.play_music(music_path)
	_noise_emitter.emit()
#endregion
