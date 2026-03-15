@tool
extends Node2D


#region Signals
signal button_pressed
#endregion


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

@export var pre_pressed : bool = false
#endregion


#region OnReady Variable
@onready var _shell: Sprite2D = %Shell

@onready var _press_sfx := %PressSFX
@onready var _press_area: Area2D = %PressArea
#endregion



#region Virtual Methods
func _ready() -> void:
	_press_area.monitoring = false
	_update_color()
	_update_shell()
	
	if Engine.is_editor_hint():
		return
	
	if pre_pressed:
		return
	var control := Global.local_controller
	if control is RoomManager:
		control.events_changed.connect(_update_shell)
	
	_after_ready()

func _after_ready() -> void:
	_press_area.monitoring = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	_press_area.monitoring = true
#endregion


#region Private Methods
func _update_color() -> void:
	_shell.modulate = color
func _update_shell() -> void:
	if pre_pressed:
		%CollisionShape2D.set_deferred(
			"disabled", true
		)
		_shell.texture = BUTTON_SHELL_PRESSED
		_shell.position.y = BUTTON_SHELL_PRESSED_Y
		return
	
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
		if !control.saw_event(event_name):
			play_effect()
			button_pressed.emit()
		control.flag_event(event_name)
#endregion


#region Public Methods
func play_effect() -> void:
	_press_sfx.play()
	Global.camera.screen_shake(
		GlobalCamera.create_noise(
			100, 100
		),
		1.0, 0.0, 0.7
	)
#endregion
