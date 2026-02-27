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


#region OnReady Variables
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _status_effect_receiver: StatusEffectReceiver = %StatusEffectReceiver
@onready var _task_manager: VelocityTaskManager = %TaskManager
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
func play_animation(animation_name : StringName) -> void:
	_animation_player.play(animation_name)
func is_animation_playing() -> bool:
	return _animation_player.is_playing()

func has_status_effect(type : StatusEffect.STATUS_TYPE) -> bool:
	return _status_effect_receiver.has_effect_type(type)

func start_task(
	node : TaskNode, args : Dictionary = {},
	overwrite : bool = true
) -> void:
	_task_manager.task_begin(node, args, overwrite)
func end_task(node : TaskNode) -> void:
	_task_manager.task_end(node)


func get_patrol_obj() -> Object:
	return _patrol_object
#endregion
