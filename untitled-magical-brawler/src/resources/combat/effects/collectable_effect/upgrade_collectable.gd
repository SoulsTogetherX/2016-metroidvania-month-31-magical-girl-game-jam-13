class_name UpgradeCollectableEffect extends BaseEffect


#region External Variables
@export var ability : AbilityData
#endregion



#region Public Virtual Methods
func implement_effect(collide_info : CollisionInfoResource) -> void:
	var entity : Player = collide_info.entity
	if entity == null:
		return
	
	entity.register_ability(ability)
#endregion
