@tool
extends Node


#region Private Variables
var active_cam : PhantomCamera2D
var requested_snap : bool = false
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
	
	active_cam = cam
	if !requested_snap:
		cam.priority = 1
		return
	requested_snap = false
	
	var duration := cam.tween_duration
	cam.tween_duration = 0.0
	cam.priority = 1
	
	await cam.tween_completed
	cam.tween_duration = duration
#endregion
