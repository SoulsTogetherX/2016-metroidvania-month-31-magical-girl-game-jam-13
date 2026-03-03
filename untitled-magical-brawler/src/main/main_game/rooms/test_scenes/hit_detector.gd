@tool
extends Sprite2D


#region External Variables
@export var flash_timer: Timer
#endregion


#region Virtual Methods
func _ready() -> void:
	set_modulate(Color.GREEN)
	flash_timer.timeout.connect(set_modulate.bind(Color.GREEN))
#endregion


#region Private Methods (On Signal)
func _on_hurtbox_hit(_collision: HitboxComponent) -> void:
	set_modulate(Color.RED)
	flash_timer.start()
#endregion
