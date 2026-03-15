extends Area2D


#region Virtual Methods
func _ready() -> void:
	monitoring = false
	monitorable = false
	
	collision_layer = 0
	collision_mask = Constants.COLLISION.PLAYER
	
	if Engine.is_editor_hint():
		return
	_after_ready()

func _after_ready() -> void:
	monitoring = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	monitoring = true
#endregion
