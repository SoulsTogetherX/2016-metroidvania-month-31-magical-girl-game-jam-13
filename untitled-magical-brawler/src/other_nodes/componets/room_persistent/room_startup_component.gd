extends Node


#region External Variables
@export_group("Settings")
@export var change_pos : bool = true
@export var change_direction : bool = true

@export_group("Other")
@export var entity : BaseEntity
#endregion



#region Virtual Methods
func _ready() -> void:
	RoomManager.on_gateway_exit.connect(_on_gateway_exit)
#endregion


#region Private Methods
func _on_gateway_exit(exit : GatewayInfo) -> void:
	if !entity:
		return
	var vel := entity.get_velocity_component()
	
	if change_pos:
		var exit_pos := exit.exit_pos
		
		if (exit.keep_offset & exit.AXIS.X) != 0:
			exit_pos.x += exit.player_offset.x
		if (exit.keep_offset & exit.AXIS.Y) != 0:
			exit_pos.y += exit.player_offset.y
		
		entity.global_position = exit_pos
	if change_direction && vel:
		vel.overwrite_direction(
			Vector2i(
				-1 if exit.facing_left else 1,
				0
			)
		)
#endregion
