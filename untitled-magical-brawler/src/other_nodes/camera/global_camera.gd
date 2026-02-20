class_name GlobalCamera extends Camera2D


#region OnReady Variables
@onready var _phantom_camera_host: PhantomCameraHost = %PhantomCameraHost
#endregion
	


#region Public Methods
func get_host() -> PhantomCameraHost:
	return _phantom_camera_host
func get_active_pcam() -> PhantomCamera2D:
	return _phantom_camera_host.get_active_pcam()
#endregion
