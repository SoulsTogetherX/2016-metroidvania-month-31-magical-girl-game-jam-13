@tool
class_name DoubleJumpAbility extends AbilityData


#region Virtual Methods
func _init() -> void:
	type = ABILITY_TYPE.DOUBLE_JUMP
#endregion


#region Public Methods (Access)
func get_ability_name() -> String:
	return "Sneky Jump"
func get_description() -> String:
	return "Jump on magic clouds to gain extra height."

func get_icon() -> Texture2D:
	return preload("uid://chwljnx2nsoh5")
#endregion
