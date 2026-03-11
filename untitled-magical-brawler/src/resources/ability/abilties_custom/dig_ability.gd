@tool
class_name DigAbility extends AbilityData


#region Constants
const EDGE_FORGIVENESS := 60
const DOWNWARDS_SEARCH := 5
#endregion



#region Virtual Methods
func _init() -> void:
	type = ABILITY_TYPE.DIG
#endregion



#region Public Methods (State Change)
static func can_start(arg : Dictionary = {}) -> bool:
	if !arg.get(&"on_ground", false):
		return false
	
	var collide : CollisionShape2D = arg.get(&"collide", null)
	var size := collide.shape.get_rect().size * 0.5
	var space := collide.get_world_2d().direct_space_state
	
	# Confirms player is not on an edge
	if Utilities.collide_point_manual(
		space, collide.global_position + Vector2(
			size.x - EDGE_FORGIVENESS, size.y + DOWNWARDS_SEARCH
		),
		Constants.COLLISION.GROUND
	).is_empty():
		return false
	if Utilities.collide_point_manual(
		space, collide.global_position + Vector2(
			-size.x + EDGE_FORGIVENESS, size.y + DOWNWARDS_SEARCH
		),
		Constants.COLLISION.GROUND
	).is_empty():
		return false
	
	# Checks if on ground
	if Utilities.collide_point_manual(
		space, collide.global_position + Vector2(
			0.0, size.y + DOWNWARDS_SEARCH
		),
		Constants.COLLISION.GROUND
	).is_empty():
		return false
	
	return true
static func can_end(arg : Dictionary = {}) -> bool:
	var collide : CollisionShape2D = arg.get(&"collide", null)
	if !collide:
		return false
	
	return Utilities.manual_collide_check(
		collide, true, false,
		Constants.COLLISION.GROUND
	).is_empty()
#endregion


#region Public Methods (Access)
func get_ability_name() -> String:
	return "Snek Dig"
func get_description() -> String:
	return "Press S to burrow under your troubles."

func get_icon() -> Texture2D:
	return preload("uid://chwljnx2nsoh5")
#endregion
