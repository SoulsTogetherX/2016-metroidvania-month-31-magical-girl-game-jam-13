@tool
class_name CannonEnemy extends Node2D


#region Constants
const CANNON_BALL = preload("uid://c0hi4lgg1uifw")
#endregion


#region External Variables
@export var face_right : bool:
	set(val):
		if val == face_right:
			return
		face_right = val
		
		if is_node_ready():
			change_dir(val)

@export_group("Start")
@export var can_deactivate : bool = true
@export var auto_start : bool = true
@export_range(0.0, 4.0, 0.001, "or_greater") var start_delay : float = 0.0

@export_group("Shoot Settings")
@export_range(0.001, 4.0, 0.001, "or_greater") var shoot_delay : float = 0.5
@export_range(0, 1000, 0.1, "or_greater") var shoot_speed : float = 700
#endregion


#region OnReady Variables
@onready var _pivot_point: Node2D = $PivotPoint

@onready var _shoot_pos: Marker2D = %ShootPos
@onready var _animation_player: AnimationPlayer = %CannnonAnimationPlayer
@onready var _timer: Timer = %Timer
#endregion



#region Virtual Methods
func _ready() -> void:
	if !can_deactivate:
		%VisibleOnScreenEnabler2D.queue_free()
		process_mode = Node.PROCESS_MODE_INHERIT
	
	change_dir(face_right)
	if auto_start && !Engine.is_editor_hint():
		start()

func _start_helper() -> void:
	_timer.one_shot = false
	_timer.wait_time = shoot_delay
	_timer.timeout.connect(play_animation)
	_timer.start()
	
	play_animation()
#endregion


#region Public Methods
func start() -> void:
	if is_zero_approx(start_delay):
		_start_helper()
		return
	
	_timer.one_shot = true
	_timer.timeout.connect(_start_helper, CONNECT_ONE_SHOT)
	_timer.start(start_delay)

func change_dir(right : bool) -> void:
	_pivot_point.scale.x = (-1.0 if right else 1.0)

func play_animation() -> void:
	_animation_player.play("ATTACK")

func shoot_bullet() -> void:
	var cannon_ball : Node2D = CANNON_BALL.instantiate()
	cannon_ball.global_position = _shoot_pos.global_position
	
	var base_dir = Vector2.RIGHT if face_right else Vector2.LEFT
	cannon_ball.direction = base_dir.rotated(global_rotation)
	cannon_ball.speed = shoot_speed
	
	owner.add_child(cannon_ball)
#endregion
