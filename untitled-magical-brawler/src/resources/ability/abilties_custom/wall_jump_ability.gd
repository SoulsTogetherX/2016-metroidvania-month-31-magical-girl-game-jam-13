@tool
class_name WallJumpAbility extends AbilityData


#region Virtual Methods
func _init() -> void:
	type = ABILITY_TYPE.WALL_JUMP
#endregion


#region Public Methods (Access)
func get_ability_name() -> String:
	return "Spare Foot of Snek"
func get_description() -> String:
	return "Three toed, three use, walljump. \n...creepy."

func get_icon() -> Texture2D:
	return preload("res://assets/sprites/other/upgrades/wall_jump_upgrade.tres")
#endregion
