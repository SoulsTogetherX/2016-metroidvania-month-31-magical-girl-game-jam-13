class_name SceneControllerManager extends Node


#region External Variables
@export_group("Internal")
@export var scene_controller : SceneController
#endregion



#region Virtual Methods
func _ready() -> void:
	Global.local_controller = self
#endregion


#region Public Methods (Accessors)
func fade_cover() -> void:
	await Global.transition_cover.fade_cover(true, 0.2)
func unfade_cover() -> void:
	await Global.transition_cover.fade_cover(false, 0.2)

func get_current_cache() -> SceneController.CachedScene:
	return scene_controller.get_current_cache()
func get_current_node() -> Node:
	return scene_controller.get_current_node()
#endregion
