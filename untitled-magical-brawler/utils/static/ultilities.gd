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


#region Collide
static func manual_collide_check(
	collide : CollisionShape2D, bodies : bool,
	areas : bool, mask : int
) -> Array[Vector2]:
	var shape := collide.shape
	var query = PhysicsShapeQueryParameters2D.new()
	
	query.shape_rid = shape.get_rid()
	query.transform = collide.get_global_transform().translated_local(
		Vector2(0, -shape.get_rect().size.y * 0.5)
	)
	query.collide_with_bodies = bodies
	query.collide_with_areas = areas
	query.collision_mask = mask
	
	var space_state := collide.get_world_2d().direct_space_state
	return space_state.collide_shape(query)
#endregion
