@tool
class_name DoubleJumpAbility extends AbilityData


#region Virtual Methods
func _init() -> void:
	type = ABILITY_TYPE.DOUBLE_JUMP
#endregion


#region Public Methods (Access)
func get_ability_name() -> StringName:
	return &"Sneky Jump"
func get_description() -> StringName:
	return &"Jump in the air to gain extra height."

func get_icon() -> Texture2D:
	return preload("uid://chwljnx2nsoh5")
#endregion
