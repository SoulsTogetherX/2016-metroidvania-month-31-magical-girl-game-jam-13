extends Node


#region Public Variables
var game_controller : GameController
var player : Player
var camera : GlobalCamera
#endregion


#region Public Methods (Helper)
func get_current_room() -> Node2D:
	return game_controller.get_node_2d_from_id(Constants.ROOM_ID)
#endregion
