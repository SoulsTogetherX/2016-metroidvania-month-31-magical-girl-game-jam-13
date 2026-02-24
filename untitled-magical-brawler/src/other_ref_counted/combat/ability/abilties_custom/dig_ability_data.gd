class_name DigAbility extends AbilityData



#region Public Methods (State Change)
func can_start(arg : Dictionary = {}) -> bool:
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
