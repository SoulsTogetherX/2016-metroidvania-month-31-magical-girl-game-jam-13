class_name AbilityCacheModule extends Node


#region Enums
const ABILITY_TYPE := AbilityData.ABILITY_TYPE
#endregion


#region External Variables
@export var abilties : Array[ABILITY_TYPE]
#endregion



#region Virtual Methods
func _ready() -> void:
	add_to_group(
		GlobalLabels.groups.SAVEABLE_GROUP_NAME
	)
#endregion


#region Private Methods (Save/Load)
func _request_save() -> void:
	SaveManager.set_key(
		SaveManager.SAVE_KEYS.ABLITIES,
		abilties
	)
func _request_load() -> void:
	var loaded = SaveManager.get_key(
		SaveManager.SAVE_KEYS.ABLITIES
	)
	
	if loaded == null:
		abilties = []
		return
	abilties = loaded
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
