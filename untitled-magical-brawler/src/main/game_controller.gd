class_name GameController extends Node


#region Enums
enum WORLD_TYPE {
	NODE_2D,
	NODE_3D,
	UI
}
enum UNMOUNT_TYPE {
	NONE,
	HIDE,
	REMOVE,
	DISABLE,
	DELETE
}
#endregion


#region External Variables
@export_group("Worlds")
@export var world_2d : Node2D
@export var world_3d : Node3D
@export var world_ui : Control
#endregion


#region Private Variables
var _world_2d_cache : Dictionary[StringName, Node2D]
var _world_3d_cache : Dictionary[StringName, Node3D]
var _world_ui_cache : Dictionary[StringName, Control]
#endregion



#region Static Methods
static func is_of_world_type(node : Node, type : WORLD_TYPE) -> bool:
	match type:
		WORLD_TYPE.NODE_2D:
			return is_instance_of(node, Node2D)
		WORLD_TYPE.NODE_3D:
			return is_instance_of(node, Node3D)
		WORLD_TYPE.UI:
			return is_instance_of(node, Control)
	return false
#endregion


#region Virtual Methods
func _ready() -> void:
	Global.game_controller = self
#endregion


#region Virtual Methods
func _change_scene_to_node(
	node : Node,
	world : Node,
	cache : Dictionary,
	id : StringName,
	mount_type : UNMOUNT_TYPE = UNMOUNT_TYPE.DELETE
) -> Node:
	if !cache.has(id) || !is_instance_valid(cache.get(id)):
		world.add_child(node)
		cache.set(id, node)
		return null
	var ret : Node = cache.get(id, node)
	world.add_child.call_deferred(node)
	
	match mount_type:
		UNMOUNT_TYPE.NONE:
			pass
		UNMOUNT_TYPE.HIDE:
			ret.visible = false
		UNMOUNT_TYPE.REMOVE:
			world.remove_child(ret)
		UNMOUNT_TYPE.DISABLE:
			ret.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		UNMOUNT_TYPE.DELETE:
			ret.queue_free()
			ret = null
	
	cache.set(id, node)
	return ret
#endregion


#region Public Methods (Change)
func change_2d_scene_to_node(
	node : Node2D,
	id : StringName,
	mount_type : UNMOUNT_TYPE = UNMOUNT_TYPE.DELETE
) -> Node:
	return _change_scene_to_node(
		node,
		world_2d,
		_world_2d_cache,
		id,
		mount_type
	)

func change_3d_scene_to_node(
	node : Node3D,
	id : StringName,
	mount_type : UNMOUNT_TYPE = UNMOUNT_TYPE.DELETE
) -> Node:
	return _change_scene_to_node(
		node,
		world_3d,
		_world_3d_cache,
		id,
		mount_type
	)

func change_ui_scene_to_node(
	node : Control,
	id : StringName,
	mount_type : UNMOUNT_TYPE = UNMOUNT_TYPE.DELETE
) -> Node:
	return _change_scene_to_node(
		node,
		world_ui,
		_world_ui_cache,
		id,
		mount_type
	)
#endregion


#region Public Methods (Accessors)
func get_node_2d_from_id(id : StringName) -> Node:
	return _world_2d_cache.get(id)
func get_node_3d_from_id(id : StringName) -> Node:
	return _world_3d_cache.get(id)
func get_ui_from_id(id : StringName) -> Node:
	return _world_ui_cache.get(id)
#endregion
