class_name Utilities


#region Dampening
static func damp(
	v1 : Variant,
	v2 : Variant,
	weight : float,
	delta : float
) -> Variant:
	return lerp(v1, v2, 1 - exp(-weight * delta))
static func dampf(
	v1 : float,
	v2 : float,
	weight : float,
	delta : float
) -> float:
	return lerpf(v1, v2, 1 - exp(-weight * delta))
static func dampv(
	v1 : Vector2,
	v2 : Vector2,
	weight : Vector2,
	delta : float
) -> Vector2:
	return Vector2(
		dampf(v1.x, v2.x, weight.x, delta),
		dampf(v1.y, v2.y, weight.y, delta)
	)
#endregion


#region Polygons
static func is_polygon_in_bounds(
	inner : PackedVector2Array,
	outer : PackedVector2Array
) -> bool:
	# Checks if any lines of the camera's poly intersects
	# the bound poly
	for i : int in range(inner.size()):
		var c1 := inner[i]
		var c2 := inner[(i + 1) % 4]
		
		for j : int in range(outer.size()):
			var b1 := outer[j]
			var b2 := outer[(j + 1) % outer.size()]
			
			if Geometry2D.segment_intersects_segment(c1, c2, b1, b2):
				return false
	
	# Finds any point guaranteed to be in the polygon
	var tri := Geometry2D.triangulate_polygon(inner)
	var centroid := (inner[tri[0]] + inner[tri[1]] + inner[tri[2]]) / 3
	
	# If no intersections, then the rect is inside poly if
	# rect's center-point is inside.
	Geometry2D.is_point_in_polygon(centroid, outer)
	return false

static func get_polygon_intersections(
	p1 : PackedVector2Array,
	p2 : PackedVector2Array
) -> PackedInt32Array:
	var ret : PackedInt32Array
	
	# Retrives all lines of the camera's poly intersects
	# the bound poly
	for i : int in range(p1.size()):
		var c1 := p1[i]
		var c2 := p1[(i + 1) % p1.size()]
		
		for j : int in range(p2.size()):
			var b1 := p2[j]
			var b2 := p2[(j + 1) % p2.size()]
			
			if Geometry2D.segment_intersects_segment(c1, c2, b1, b2):
				ret.append_array([
					i, (i + 1) % p1.size(),
					j, (j + 1) % p2.size()
				])
	return ret
#endregion
