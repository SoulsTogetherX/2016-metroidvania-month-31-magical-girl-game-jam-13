@tool
class_name CheckPoint extends Area2D


#region External Variables
@export var info : PlayerPositionResource
#endregion



#region Virtual Methods
func _ready() -> void:
	info = PlayerPositionResource.new()
	info.exit_pos = global_position
	monitoring = true
	monitorable = false
	
	collision_layer = 0
	collision_mask = Constants.COLLISION.PLAYER
	
	if Engine.is_editor_hint():
		return
	body_entered.connect(_on_player_enter)
#endregion


#region Private Methods (On Signal)
func _on_player_enter(player : Node2D) -> void:
	if !(player is Player):
		return
	
	var room_manager : RoomManager = (Global.local_controller as RoomManager)
	if room_manager != null:
		room_manager.register_checkpoint(info)
#endregion
