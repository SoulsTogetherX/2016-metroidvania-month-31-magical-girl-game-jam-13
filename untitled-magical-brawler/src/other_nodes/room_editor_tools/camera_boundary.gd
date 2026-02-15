@tool
class_name CameraBoundary extends StaticBody2D


#region Constants
const BASE_COLOR := Color(0.0, 1.0, 1.0, 0.05)
const COLLISION_POLYGON_NAME := "CameraCollider"
#endregion


#region Private Variables
var _collision: Node = null
#endregion



#region Virtual Methods
func _ready() -> void:
	if !Engine.is_editor_hint():
		return
	call_deferred("_collision_settup")
#endregion


#region Private Methods
func _collision_settup() -> void:
	_collision = get_node_or_null(COLLISION_POLYGON_NAME)
	if !_collision:
		_create_collision_polygon()
	_adjust_collision(_collision)

func _create_collision_polygon() -> void:
	_collision = CollisionPolygon2D.new()
	add_child(_collision)
	_collision.owner = owner
	_collision.name = COLLISION_POLYGON_NAME
func _adjust_collision(collision : CollisionPolygon2D) -> void:
	collision.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
	
	if collision.polygon.size() <= 3:
		collision.polygon = [
			Vector2.ZERO,
			Vector2.ZERO,
			Vector2.ZERO
		]
#endregion
