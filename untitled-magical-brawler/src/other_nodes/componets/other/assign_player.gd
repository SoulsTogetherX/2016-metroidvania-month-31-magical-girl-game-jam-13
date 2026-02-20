class_name AssignPlayer extends Node


#region External Variables
@export var property_name : StringName
#endregion



#region Virtual Methods
func _ready() -> void:
	get_parent().set(property_name, Global.player)
#endregion
