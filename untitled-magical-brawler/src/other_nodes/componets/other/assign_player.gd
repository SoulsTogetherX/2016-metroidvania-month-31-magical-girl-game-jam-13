class_name AssignPlayer extends Node



#region External Variables
@export var follow_offset : bool = true
@export var limit : TileMapLayer
#endregion



#region Virtual Methods
func _ready() -> void:
	var phantom : PhantomCamera2D = get_parent()
	phantom.follow_mode = PhantomCamera2D.FollowMode.GLUED
	if limit:
		phantom.limit_target = limit.get_path()
	
	if follow_offset:
		phantom.follow_target = Global.player.get_camera_lead()
		return
	phantom.follow_target = Global.player
#endregion
