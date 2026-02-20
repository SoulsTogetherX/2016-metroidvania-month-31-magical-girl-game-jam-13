@tool
extends Node


#region Private Variables
var _registered : Array[PhantomCamera2D]
#endregion



#region Public Methods (Register)
func clear_registered() -> void:
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
		phantom_camera.priority = 1
#endregion
