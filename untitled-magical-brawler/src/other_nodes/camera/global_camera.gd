class_name GlobalCamera extends Camera2D


#region External Variables
@export var toggle : bool = true:
	set = toggle_camera
#endregion


#region OnReady Variables
@onready var _phantom_camera_host: PhantomCameraHost = %PhantomCameraHost
#endregion


#region OnReady Methods
func _ready() -> void:
	toggle_camera(toggle)

func _physics_process(delta: float) -> void:
	_phantom_camera_host.process(delta)
#endregion


#region Public Methods
func get_host() -> PhantomCameraHost:
	return _phantom_camera_host
func get_active_pcam() -> PhantomCamera2D:
	return _phantom_camera_host.get_active_pcam()

func toggle_camera(val : bool) -> void:
	toggle = val
	set_physics_process(val)
#endregion
