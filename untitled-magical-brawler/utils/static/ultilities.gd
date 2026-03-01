class_name Utilities extends Object


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
	
	return shape_collide_check(
		collide.get_world_2d().direct_space_state,
		collide.get_global_transform().translated_local(
			Vector2(0, -shape.get_rect().size.y * 0.5)
		),
		shape, bodies, areas, mask
	)
static func shape_collide_check(
	world : PhysicsDirectSpaceState2D, transform : Transform2D,
	shape : Shape2D, bodies : bool,
	areas : bool, mask : int
) -> Array[Vector2]:
	var query = PhysicsShapeQueryParameters2D.new()
	
	query.shape_rid = shape.get_rid()
	query.transform = transform
	query.collide_with_bodies = bodies
	query.collide_with_areas = areas
	query.collision_mask = mask
	
	return world.collide_shape(query)

static func collide_point_manual(
	world : PhysicsDirectSpaceState2D,
	position : Vector2, mask : int,
	bodies : bool = true, areas : bool = false,
	canvas_instance_id : int = 0
) -> Array[Dictionary]:
	var query := PhysicsPointQueryParameters2D.new()
	query.collision_mask = mask
	query.position = position
	query.collide_with_bodies = bodies
	query.collide_with_areas = areas
	query.canvas_instance_id = canvas_instance_id

	return world.intersect_point(query)

static func raycast_manual(
	from : Node2D, length : float,
	mask : int, bodies : bool = true,
	areas : bool = false, hit_from_inside : bool = true
) -> Dictionary:
	var space_state := from.get_world_2d().direct_space_state
	var origin := from.global_position
	var end := from.global_position + Vector2(0, length)
	
	var query := PhysicsRayQueryParameters2D.create(origin, end)
	query.hit_from_inside = hit_from_inside
	query.collide_with_bodies = bodies
	query.collide_with_areas = areas
	query.collision_mask = mask
	
	return space_state.intersect_ray(query)
#endregion
