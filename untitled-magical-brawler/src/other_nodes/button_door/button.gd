@tool
extends Node2D


#region Constants
const BUTTON_SHELL_PRESSED = preload("uid://ceb2xyvwaubo3")
const BUTTON_SHELL_UNPRESSED = preload("uid://bp6sda6hpd4jg")

const BUTTON_SHELL_PRESSED_Y := -71.0
const BUTTON_SHELL_UNPRESSED_Y := -87.0
#endregion


#region External Variable
@export var color : Color = Color.WHITE:
	set(val):
		if val == color:
			return
		color = val
		
		if is_node_ready():
			_update_color()
@export var event_name : StringName
#endregion


#region OnReady Variable
@onready var _shell: Sprite2D = %Shell
#endregion



#region Virtual Methods
func _ready() -> void:
	_update_color()
	_update_shell()
	
	if Engine.is_editor_hint():
		return
	
	var control := Global.local_controller
	if control is RoomManager:
		control.events_changed.connect(_update_shell)
#endregion


#region Private Methods
func _update_color() -> void:
	_shell.modulate = color
func _update_shell() -> void:
	if Engine.is_editor_hint():
		_shell.texture = BUTTON_SHELL_UNPRESSED
		_shell.position.y = BUTTON_SHELL_UNPRESSED_Y
		return
	
	var control := Global.local_controller
	if control is RoomManager:
		if control.saw_event(event_name):
			%CollisionShape2D.set_deferred(
				"disabled", true
			)
			_shell.texture = BUTTON_SHELL_PRESSED
			_shell.position.y = BUTTON_SHELL_PRESSED_Y
			return
		_shell.texture = BUTTON_SHELL_UNPRESSED
		_shell.position.y = BUTTON_SHELL_UNPRESSED_Y

func _press_button() -> void:
	var control := Global.local_controller
	if control is RoomManager:
		control.flag_event(event_name)
#endregion
