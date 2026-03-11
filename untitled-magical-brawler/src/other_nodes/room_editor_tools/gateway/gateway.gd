@tool
class_name Gateway extends Area2D


#region External Variables
@export_group("Entering Player")
@export var info : PlayerPositionResource

@export_group("Music")
@export_file_path("*.ogg") var music_path : String = "res://assets/music/1. Mushroom Dungeon.ogg"

@export_group("Ids")
@export var id : int

@export_subgroup("Exit")
@export var exit_id : int
@export_file_path("*.tscn") var exit_path: String
#endregion



#region Virtual Methods
func _ready() -> void:
	info.exit_pos = global_position
	monitoring = false
	monitorable = false
	
	collision_layer = 0
	collision_mask = Constants.COLLISION.PLAYER
	
	if Engine.is_editor_hint():
		return
	
	body_entered.connect(_on_player_enter)
	_register_self()
	_after_ready()

func _after_ready() -> void:
	monitoring = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	monitoring = true
#endregion


#region Private Methods (Helper)
func _register_self() -> void:
	var room_manager : RoomManager = (Global.local_controller as RoomManager)
	if room_manager != null:
		room_manager.register_gateway(self)
#endregion


#region Private Methods (On Signal)
func _on_player_enter(player : Node2D) -> void:
	if !(player is Player):
		return
	
	var room_manager : RoomManager = (Global.local_controller as RoomManager)
	if room_manager != null:
		room_manager.change_room_to_path(exit_path, exit_id)
#endregion
