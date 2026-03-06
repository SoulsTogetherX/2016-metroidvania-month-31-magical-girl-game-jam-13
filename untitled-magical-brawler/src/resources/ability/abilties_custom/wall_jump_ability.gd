class_name WallJumpAbility extends AbilityData


#region Virtual Methods
func _init() -> void:
	type = ABILITY_TYPE.WALL_JUMP
#endregion



#region Public Methods (Access)
func get_ability_name() -> StringName:
	return &"Snek Wall Jump"
func get_description() -> StringName:
	return &"Jump on a wall to scale heigher."

func get_icon() -> Texture2D:
	return preload("uid://chwljnx2nsoh5")
#endregion
