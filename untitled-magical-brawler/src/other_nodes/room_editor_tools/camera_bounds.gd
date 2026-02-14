@tool
class_name CameraBounds extends Polygon2D


#region Constants
const BASE_COLOR := Color(0.0, 1.0, 1.0, 0.1)
#endregion


#region Private Variables
var _baked_polygon : PackedVector2Array
#endregion



#region Virtual Methods
func _ready() -> void:
	color = BASE_COLOR
	bake_polygon()
#endregion


#region Public Methods (Baking Polygons)
func bake_polygon() -> void:
	_baked_polygon.resize(polygon.size())
	for i : int in range(polygon.size()):
		_baked_polygon[i] = polygon[i] - global_position - offset

func get_baked_polygons() -> PackedVector2Array:
	return _baked_polygon
#endregion
