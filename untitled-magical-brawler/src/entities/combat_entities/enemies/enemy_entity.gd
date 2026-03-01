@tool
class_name Enemy extends CombatEntity


#region Enums
enum PATROL_TYPE {
	NONE,
	STATIONARY,
	WANDER,
	PATH
}
#endregion


#region External Variables
@export var patrol_type : PATROL_TYPE:
	set(val):
		if val == patrol_type:
			return
		patrol_type = val
		notify_property_list_changed()
#endregion


#region Private Variable
@export_storage var _patrol_object : Object = null
#endregion



#region Virtual Methods
func _get_property_list() -> Array[Dictionary]:
	var ret : Array[Dictionary] = []
	
	match patrol_type:
		PATROL_TYPE.STATIONARY:
			ret.push_back({
				"name": &"patrol_marker",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_NODE_TYPE,
				"hint_string": &"Marker2D"
			})
		PATROL_TYPE.WANDER:
			ret.push_back({
				"name": &"patrol_area",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_NODE_TYPE,
				"hint_string": &"CollisionShape2D"
			})
		PATROL_TYPE.PATH:
			ret.push_back({
				"name": &"patrol_path",
				"usage": PROPERTY_USAGE_DEFAULT,
				"type": TYPE_OBJECT,
				"hint": PROPERTY_HINT_NODE_TYPE,
				"hint_string": &"Path2D"
			})
	
	return ret

func _set(property: StringName, value: Variant) -> bool:
	if property in [&"patrol_marker", &"patrol_area", &"patrol_path"]:
		_patrol_object = value
		return true
	return false
func _get(property: StringName) -> Variant:
	if property in [&"patrol_marker", &"patrol_area", &"patrol_path"]:
		return _patrol_object
	return null
#endregion


#region Public Methods
func get_patrol_obj() -> Object:
	return _patrol_object
#endregion
