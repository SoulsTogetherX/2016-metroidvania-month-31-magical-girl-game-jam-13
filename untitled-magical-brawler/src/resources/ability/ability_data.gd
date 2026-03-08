@abstract
@tool
class_name AbilityData extends Resource


#region Private Signals
enum ABILITY_TYPE {
	DIG,
	DOUBLE_JUMP,
	WALL_JUMP
}
#endregion


#region Public Signals
var type : ABILITY_TYPE
#endregion



#region Public Methods (Access)
@abstract
func get_ability_name() -> StringName
@abstract
func get_description() -> StringName

@abstract
func get_icon() -> Texture2D
#endregion
