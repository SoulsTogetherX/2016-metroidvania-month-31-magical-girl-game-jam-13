extends VelocityTaskNode


#region External Variables
@export_group("Other")
@export var actor : Camera2D
@export var camera_bounds : CameraBounds
#endregion



#region Public Methods (Helper)
func get_camera_bounds(camera : Camera2D) -> PackedVector2Array:
	var camera_size := camera.get_viewport_rect().size / camera.zoom
	
	var top_left := camera.global_position + camera.offset
	var bottom_right := top_left
	
	if camera.anchor_mode == Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT:
		bottom_right += camera_size
	else:
		var half_size := camera_size / 2
		top_left -= half_size
		bottom_right += half_size
	
	var ret : PackedVector2Array
	ret.resize(4)
	ret[0] = top_left
	ret[1] = Vector2(bottom_right.x, top_left.y) # top_right
	ret[2] = bottom_right
	ret[3] = Vector2(top_left.x, bottom_right.y) # bottom_left
	
	return ret
#endregion


#region Public Virtual Methods
func task_physics(_delta : float, args : Dictionary) -> bool:
	#var velocity_c := get_velocity(args)
	var act : Node2D = args.get(&"actor", actor)
	var bounds : CameraBounds = args.get(&"camera_bounds", camera_bounds)
	
	var cam_poly := get_camera_bounds(act)
	var bounds_poly := bounds.get_baked_polygons()
	
	var intersections := Utilities.get_polygon_intersections(
		cam_poly, bounds_poly
	)
	
	# Intersections come in pairs of 8
	for i : int in range(intersections.size() >> 3):
		var idx := i << 3
		
		var c1 := cam_poly[intersections[idx]]
		var c2 := cam_poly[intersections[idx + 1]]
		var c3 := cam_poly[intersections[idx + 4]]
		var c4 := cam_poly[intersections[idx + 5]]
		var b1 := bounds_poly[intersections[idx + 2]]
		var b2 := bounds_poly[intersections[idx + 3]]
		var b3 := bounds_poly[intersections[idx + 6]]
		var b4 := bounds_poly[intersections[idx + 7]]
		
		var s1 : Vector2 = Geometry2D.segment_intersects_segment(c1, c2, b1, b2)
		var s2 : Vector2 = Geometry2D.segment_intersects_segment(c3, c4, b3, b4)
		
		prints(s1, s2)
		#act.global_position -= (
		#	
		#)
	
	return true
#endregion
	

#region Public Methods (Action States)
func task_begin(args : Dictionary) -> bool:
	if get_velocity(args) == null:
		return false
	
	var act : Node2D = args.get(&"actor", actor)
	if !act:
		return false
	
	var bounds : CameraBounds = args.get(&"camera_bounds", camera_bounds)
	if !bounds:
		return false
	
	return true
#endregion


#region Public Methods (Identifier)
func task_id() -> StringName:
	return &"Bound_Camera_Task"
#endregion
