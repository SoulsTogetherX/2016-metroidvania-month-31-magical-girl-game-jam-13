class_name SceneController extends Node


#region Enums
enum UNMOUNT_TYPE {
	NONE,
	HIDE,
	REMOVE,
	DISABLE,
	DELETE
}
#endregion


#region External Variables
@export var world_parent : Node
#endregion


#region Private Variables
var _node_cache : Dictionary[String, CachedScene]

@warning_ignore("unused_private_class_variable")
var _current_cache : CachedScene
#endregion



#region Virtual Methods
func _ready() -> void:
	if world_parent == null:
		world_parent = self
#endregion


#region Private Methods
func _clear_current(
	old_scene : CachedScene,
	mount_type : UNMOUNT_TYPE = UNMOUNT_TYPE.DELETE
) -> Node:
	if old_scene == null:
		return
	var old_node : Node = old_scene.get_node()
	
	match mount_type:
		UNMOUNT_TYPE.NONE:
			pass
		UNMOUNT_TYPE.HIDE:
			old_node.visible = false
		UNMOUNT_TYPE.REMOVE:
			world_parent.remove_child(old_node)
		UNMOUNT_TYPE.DISABLE:
			old_node.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		UNMOUNT_TYPE.DELETE:
			_node_cache.erase(old_scene.get_id())
			old_node = null
	return old_node

func _background_load_node(
	scene : CachedScene
) -> void:
	var new_id := scene.get_id()
	_node_cache.set(new_id, scene)
func _change_scene_to_node(
	scene : CachedScene,
	mount_type : UNMOUNT_TYPE = UNMOUNT_TYPE.DELETE,
	wait : bool = true
) -> Node:
	if wait && !scene.is_finished():
		await scene.get_finished_signal()
	
	_clear_current(_current_cache, mount_type)
	
	var new_node : Node = scene.get_node()
	new_node.process_mode = Node.PROCESS_MODE_INHERIT
	if new_node is Node2D || new_node is Node3D || new_node is Control:
		new_node.visible = true 
	if new_node.get_parent() == null:
		world_parent.add_child.call_deferred(new_node)
	
	_node_cache.set(scene.get_id(), scene)
	_current_cache = scene
	
	return new_node
#endregion


#region Public Methods (Change)
func clear_cache() -> void:
	_node_cache.clear()
	_node_cache.set(
		_current_cache.get_id(),
		_current_cache
	)
func background_load_path(
	path : String
) -> void:
	if path.is_empty():
		return
	_background_load_node(
		CachedScene.new(
			path, get_tree().process_frame
		)
	)
func change_scene_to_path(
	path : String,
	mount_type : UNMOUNT_TYPE = UNMOUNT_TYPE.DELETE,
	wait : bool = true
) -> Node:
	if path.is_empty():
		return null
		
	return await _change_scene_to_node(
		CachedScene.new(
			path, get_tree().process_frame
		),
		mount_type, wait
	)
#endregion


#region Public Methods (Accessors)
func get_current_cache() -> CachedScene:
	return _current_cache
func get_current_node() -> Node:
	return _current_cache.get_node()
#endregion


#region Inner Classes
class CachedScene:
	var _task : BackgroundLoader.Task
	var _node : Node = null
	
	func _init(packed : String, sig : Signal) -> void:
		_task = BackgroundLoader.request_resource(
			packed, "PackedScene", sig
		)
	func _notification(what: int) -> void:
		match what:
			NOTIFICATION_PREDELETE:
				if _node != null:
					_node.queue_free()
	
	func get_node() -> Node:
		if _node == null:
			_node = (_task.get_resource() as PackedScene).instantiate()
		return _node
	func is_finished() -> bool:
		return _task.is_finished()
	func get_finished_signal() -> Signal:
		return _task.finished
	
	func get_id() -> String:
		return _task.get_resource_path()
#endregion
