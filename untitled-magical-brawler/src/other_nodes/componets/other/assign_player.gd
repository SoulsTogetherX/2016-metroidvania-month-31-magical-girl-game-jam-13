class_name AssignPlayer extends Node


#region External Variables
@export var property_name : StringName
#endregion



#region Virtual Methods
func _ready() -> void:
	var phantom : PhantomCamera2D = get_parent()
	phantom.follow_mode = PhantomCamera2D.FollowMode.GLUED
	phantom.follow_target = Global.player.get_camera_lead()
#endregion
