@tool
extends Node


#region Private Variables
var _registered : Array[PhantomCamera2D]
var _snap_camera : bool = true
#endregion


#region Public Methods (Register)
func clear_registered() -> void:
	_snap_camera = true
	_registered.clear()
func register_camera(phantom_camera : PhantomCamera2D) -> void:
	assert(!(phantom_camera in _registered), "Attempted to register an existing camera")
	_registered.append(phantom_camera)
#endregion


#region Public Methods (Prioirty)
func clear_prioirties() -> void:
	for camera : PhantomCamera2D in _registered:
		camera.priority = 0
func focus_camera(phantom_camera : PhantomCamera2D) -> void:
	clear_prioirties()
	if phantom_camera:
		var duration : float
		
		if _snap_camera:
			duration = phantom_camera.tween_resource.duration
			phantom_camera.tween_resource.duration = 0.0
		phantom_camera.priority = 1
		if _snap_camera:
			phantom_camera.tween_resource.duration = duration
			_snap_camera = false
#endregion
