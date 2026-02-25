class_name DigAbility extends AbilityData


#region Constants
const EDGE_FORGIVENESS := 60
#endregion



#region Public Methods (State Change)
func can_start(arg : Dictionary = {}) -> bool:
	var collide : CollisionShape2D = arg.get(&"collide", null)
	var size := collide.shape.get_rect().size
	var space := collide.get_world_2d().direct_space_state
	
	# Confirms player is not on an edge
	if Utilities.collide_point_manual(
		space, collide.global_position + Vector2(
			size.x - EDGE_FORGIVENESS, size.y
		),
		Constants.COLLISION.GROUND
	).is_empty():
		return false
	if Utilities.collide_point_manual(
		space, collide.global_position + Vector2(
			-size.x + EDGE_FORGIVENESS, size.y
		),
		Constants.COLLISION.GROUND
	).is_empty():
		return false
	
	# Confirms player is on the ground
	return arg.get(&"on_ground", false)
func can_end(arg : Dictionary = {}) -> bool:
	var collide : CollisionShape2D = arg.get(&"collide", null)
	if !collide:
		return false
		
	return Utilities.manual_collide_check(
		collide, true, false,
		Constants.COLLISION.GROUND
	).is_empty()
#endregion


#region Public Methods (Access)
func get_ability_name() -> StringName:
	return &""
func get_description() -> StringName:
	return &""

func get_icon() -> Texture2D:
	return null

func get_ability_type() -> ABILITY_TYPE:
	return ABILITY_TYPE.DIG
#endregion
