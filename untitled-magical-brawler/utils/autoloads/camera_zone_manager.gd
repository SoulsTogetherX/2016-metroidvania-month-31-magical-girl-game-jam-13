@tool
extends Node



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
	cam.priority = 1
#endregion
