class_name AbilityResource extends Resource


#region Private Signals
signal _request_end
#endregion


#region External Variables
@export var ability_name : String
@export var texture : Texture2D
#endregion



#region Public Methods (State Change)
func ability_start() -> void:
	pass
func ability_end() -> void:
	pass
#endregion


#region Public Methods (Force Change)
func force_end() -> void:
	_request_end.emit()
#endregion


#region Public Methods (Check)
func is_vaild(_action_cache : ActionCacheComponent) -> bool:
	return true
#endregion
