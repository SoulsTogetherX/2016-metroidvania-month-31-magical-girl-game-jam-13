@tool
class_name PlayerDetecter extends Area2D


#region Constants
const COLLIDER_NAME := "PlayerDetectionArea"
const DEBUG_COLOR := Color(Color.BLUE_VIOLET, 0.2)
#endregion



#region Virtual Variables
func _ready() -> void:
	monitorable = false
	monitoring = true
	
	collision_layer = 0
	collision_mask = Constants.COLLISION.PLAYER
	
	EditorUtilities.confirmed_child(
		self,
		&"",
		COLLIDER_NAME,
		_create_collider,
		func(_node): pass,
		0
	)
#endregion


#region Private Methods (Confirmed Children)
func _create_collider() -> CollisionShape2D:
	var node := CollisionShape2D.new()
	node.debug_color = DEBUG_COLOR
	
	return node
#endregion
