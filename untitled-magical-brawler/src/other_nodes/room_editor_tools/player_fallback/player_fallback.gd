class_name PlayerFallback extends Marker2D


#region External Variables
@export_group("Entering Player")
@export var info : PlayerPositionResource
#endregion



#region Virtual Methods
func _ready() -> void:
	info.exit_pos = global_position
#endregion
