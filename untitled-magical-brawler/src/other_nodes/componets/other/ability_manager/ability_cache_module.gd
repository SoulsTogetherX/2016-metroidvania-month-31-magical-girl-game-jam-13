class_name AbilityCacheModule extends Node


#region Enums
const ABILITY_TYPE := AbilityData.ABILITY_TYPE
#endregion


#region External Variables
@export var abilties : Array[ABILITY_TYPE]
#endregion



#region Public Methods
func register_ability(ability : ABILITY_TYPE) -> void:
	if ability in abilties:
		return
	abilties.append(ability)
#endregion


#region Public Methods (Helper)
func size() -> int:
	return abilties.size()
func is_empty() -> bool:
	return abilties.is_empty()

func has_ability(type : ABILITY_TYPE) -> bool:
	return type in abilties
#endregion
