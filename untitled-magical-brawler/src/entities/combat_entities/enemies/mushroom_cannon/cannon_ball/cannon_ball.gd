extends Node2D


#region External Variables
@export var direction : Vector2
@export var speed : float = 500
#endregion


#region OnReady Variables
@onready var _particles: OneshotParticles = %ExplodeParticles
#endregion



#region Virtual Methods
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
#endregion


#region Private Methods
func _on_ground_collide() -> void:
	_particles.start_final_emit(get_parent())
	queue_free()
#endregion
