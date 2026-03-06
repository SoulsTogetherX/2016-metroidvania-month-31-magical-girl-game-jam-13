class_name AssignPlayerPath extends AssignPlayer



#region External Variables
@export var path : Path2D
#endregion



#region Virtual Methods
func _ready() -> void:
	super()
	var phantom : PhantomCamera2D = get_parent()
	phantom.follow_mode = PhantomCamera2D.FollowMode.PATH
	
	if path:
		phantom.follow_path = path
#endregion
