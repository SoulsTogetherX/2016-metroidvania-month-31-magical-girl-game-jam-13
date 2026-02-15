@tool
extends CharacterBody2D


#region Constants
const DEBUG_COLOR := Color(0.0, 1.0, 0.0, 0.0)
#endregion


#region External Variables
@export var offset : Vector2:
	set(val):
		if val == offset:
			return
		offset = val
		
		if _camera:
			_camera.offset = val
			update_collison_shape()
@export var zoom : Vector2 = Vector2(0.4, 0.4):
	set(val):
		if val == zoom || val.is_zero_approx():
			return
		zoom = val
		
		if _camera:
			_camera.zoom = val
			update_collison_shape()
#endregion


#region Private Variables
var _camera: Camera2D

var _collide: CollisionShape2D
var _shape: RectangleShape2D
#endregion



#region Virtual Methods
func _ready() -> void:
	_camera = Camera2D.new()
	_camera.offset = offset
	_camera.zoom = zoom
	add_child(_camera)
	
	_shape = RectangleShape2D.new()
	_collide = CollisionShape2D.new()
	_collide.shape = _shape
	add_child(_collide)
	
	_collide.debug_color = DEBUG_COLOR
	
	update_collison_shape()
#endregion


#region Public Methods
func update_collison_shape() -> void:
	var camera_size := _camera.get_viewport_rect().size / _camera.zoom
	_shape.size = camera_size
	_collide.global_position = _camera.get_screen_center_position()
	_collide.global_rotation = _camera.get_screen_rotation() - _camera.global_rotation

func get_camera() -> Camera2D:
	return _camera
#endregion
