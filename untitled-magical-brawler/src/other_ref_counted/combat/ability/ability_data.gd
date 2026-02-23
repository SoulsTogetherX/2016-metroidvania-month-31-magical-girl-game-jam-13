@abstract
class_name AbilityData extends Resource #RefCounted


#region Private Signals
signal _request_end
#endregion


#region Private Signals
enum ABILITY_TYPE {
	DIG,
}
#endregion



#region Public Methods (State Change)
func ability_passthrough(_action_cache : ActionCacheComponent) -> bool:
	return true

func ability_start() -> void:
	pass
func ability_end() -> void:
	pass
#endregion


#region Public Methods (Force Change)
func force_end() -> void:
	_request_end.emit()
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
