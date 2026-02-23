class_name DigAbility extends AbilityData



#region Public Methods (State Change)
func is_vaild(_action_cache : ActionCacheComponent) -> bool:
	return true
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
