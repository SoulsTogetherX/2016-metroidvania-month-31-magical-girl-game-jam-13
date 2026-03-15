extends Node2D


#region External Variables
@export var direction : Vector2
@export var speed : float = 500
#endregion


#region Private Variables
var _rotate_delta : float
#endregion


#region OnReady Variables
@onready var _sprite: Sprite2D = %Sprite2D
@onready var _particles: OneshotParticles = %ExplodeParticles
#endregion



#region Virtual Methods
func _ready() -> void:
	_sprite.frame = randi() % _sprite.hframes
	_rotate_delta = randf_range(-10.0, 10.0)
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	rotation_degrees += _rotate_delta
#endregion


#region Private Methods
func _on_collide() -> void:
	_particles.start_final_emit(get_parent())
	queue_free()
#endregion
