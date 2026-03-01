@tool
class_name WanderArea extends CollisionShape2D


#region Constants
const DEBUG_COLOR := Color(Color.YELLOW, 0.2)
#endregion



#region Virtual Variables
func _ready() -> void:
	debug_color = DEBUG_COLOR
	
	if shape == null:
		shape = RectangleShape2D.new()
#endregion


#region Private Variables
func _get_point_in_rect() -> Vector2:
	var extents : Vector2 = shape.extents
	
	return Vector2(
		randf_range(-extents.x, extents.x),
		randf_range(-extents.y, extents.y)
	) + global_position
#endregion


#region Public Variables
func get_random_point() -> Vector2:
	if shape is RectangleShape2D:
		return _get_point_in_rect()
	return Vector2.ZERO
#endregion
