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
@export var player_detect : PlayerDetecter
@export var patrol_type : PATROL_TYPE:
	set(val):
		if val == patrol_type:
			return
		patrol_type = val
		notify_property_list_changed()
#endregion


#region Private Variables
@export_storage var _patrol_object : Object = null

var _patrol_point : Vector2
#endregion


#region OnReady Variables
@onready var _hsm_context: HSMContext = %HSMContext
#endregion


#region Public Variables
var get_target_point : Callable = func() -> Vector2: return Vector2.ZERO
#endregion



#region Virtual Methods
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if !player_detect:
		push_error("Enemy has no way to detect player")
		return
	player_detect.body_entered.connect(_player_entered)
	player_detect.body_exited.connect(_player_exited)

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
				"hint_string": &"WanderArea"
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


#region Private Methods
func _player_entered(body : Node2D) -> void:
	if !(body is Player):
		return
	
	_hsm_context.set_action(GlobalLabels.hsm_context.ACT_PURSUING_PLAYER, true)
	_hsm_context.set_action(GlobalLabels.hsm_context.ACT_SPOTTED_PLAYER, true)
func _player_exited(body : Node2D) -> void:
	if !(body is Player):
		return
	_hsm_context.set_action(GlobalLabels.hsm_context.ACT_SPOTTED_PLAYER, false)
#endregion


#region Public Methods
func get_patrol_obj() -> Object:
	return _patrol_object
#endregion


#region Public Methods (Helper)
func update_patrol_point() -> void:
	match patrol_type:
		PATROL_TYPE.NONE:
			pass
		PATROL_TYPE.STATIONARY:
			_patrol_point = (_patrol_object as Marker2D).global_position
		PATROL_TYPE.WANDER:
			_patrol_point = (_patrol_object as WanderArea).get_random_point()
		PATROL_TYPE.PATH:
			pass
	_hsm_context.force_action_signal.call_deferred(
		GlobalLabels.hsm_context.ACT_MOVING
	)
func get_patrol_point() -> Vector2:
	return _patrol_point
#endregion
