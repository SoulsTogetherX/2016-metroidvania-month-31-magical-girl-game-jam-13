@abstract
class_name AbilityData extends Resource #RefCounted


#region Private Signals
enum ABILITY_TYPE {
	DIG,
}
#endregion



#region Public Methods (Can Checks)
func can_start(_arg : Dictionary = {}) -> bool:
	return true
func can_end(_arg : Dictionary = {}) -> bool:
	return true
#endregion


#region Public Methods (Access)
@abstract
func get_ability_name() -> StringName
@abstract
func get_description() -> StringName

@abstract
func get_icon() -> Texture2D

@abstract
func get_ability_type() -> ABILITY_TYPE
#endregion


#region Public Methods (Helper)
func add_to_dic(dic : Dictionary[ABILITY_TYPE, AbilityData]) -> void:
	dic[get_ability_type()] = self

func is_in_dic(dic : Dictionary[ABILITY_TYPE, AbilityData]) -> bool:
	return dic.has(get_ability_type())
#endregion
