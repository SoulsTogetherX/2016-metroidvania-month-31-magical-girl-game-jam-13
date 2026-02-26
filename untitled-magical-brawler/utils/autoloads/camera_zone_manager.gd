@tool
extends Node


#region Private Variables
var _snap_requested : bool
#endregion



#region Public Methods (Camera Focus)
func unfocus_all() -> void:
	for cam : PhantomCamera2D in get_tree().get_nodes_in_group(
		GlobalLabels.objects.CAMERA_ZONE_GROUP_NAME
	):
		cam.priority = 0
func focus_camera(cam : PhantomCamera2D, snap : bool = false) -> void:
	unfocus_all()
	if !cam:
		return
	if !snap && !_snap_requested:
		cam.priority = 1
		return
	_snap_requested = false
	
	var duration := cam.tween_duration
	cam.tween_duration = 0.0
	cam.priority = 1
	cam.tween_duration = duration
#endregion


#region Public Methods (Helper)
func request_snap() -> void:
	_snap_requested = true
#endregion
