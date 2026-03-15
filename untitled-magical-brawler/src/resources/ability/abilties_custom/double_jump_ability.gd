@tool
class_name DoubleJumpAbility extends AbilityData


#region Virtual Methods
func _init() -> void:
	type = ABILITY_TYPE.DOUBLE_JUMP
#endregion


#region Public Methods (Access)
func get_ability_name() -> String:
	return "Sneky Boots"
func get_description() -> String:
	return "Use fashion to jump in the air."

func get_icon() -> Texture2D:
	return preload("res://assets/sprites/other/upgrades/double_jump_upgrade.tres")
#endregion
