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
func fade_cover(delay : float = 0.2) -> void:
	await Global.transition_cover.fade_cover(true, delay)
func unfade_cover(delay : float = 0.2) -> void:
	await Global.transition_cover.fade_cover(false, delay)

func get_current_cache() -> SceneController.CachedScene:
	return scene_controller.get_current_cache()
func get_current_node() -> Node:
	return scene_controller.get_current_node()
#endregion
