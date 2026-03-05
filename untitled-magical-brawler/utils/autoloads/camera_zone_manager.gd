@tool
extends Node


#region Private Variables
var snap_requested : bool
#endregion



#region Public Methods (Camera Focus)
func unfocus_all() -> void:
	for cam : PhantomCamera2D in get_tree().get_nodes_in_group(
		GlobalLabels.objects.CAMERA_ZONE_GROUP_NAME
	):
		cam.priority = 0
func focus_camera(cam : PhantomCamera2D) -> void:
	unfocus_all()
	if !cam:
		return
	if !snap_requested:
		cam.priority = 1
		return
	set_deferred("snap_requested", false)
	
	if is_zero_approx(cam.tween_duration):
		return
	
	var duration := cam.tween_duration
	cam.tween_duration = 0.0
	cam.priority = 1
	cam.set_deferred("tween_duration", duration)
#endregion


#region Public Methods (Helper)
func request_snap() -> void:
	snap_requested = true
#endregion
