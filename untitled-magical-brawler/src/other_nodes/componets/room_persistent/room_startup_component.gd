extends Node


#region External Variables
@export_group("Settings")
@export var change_pos : bool = true
@export var change_direction : bool = true

@export_group("Other")
@export var entity_manager : BaseEntityManager
#endregion



#region Virtual Methods
func _ready() -> void:
	RoomManager.on_gateway_exit.connect(_on_gateway_exit)
#endregion


#region Private Methods
func _on_gateway_exit(exit : GatewayInfo) -> void:
	var vel := entity_manager.get_velocity_component()
	var act := entity_manager.get_actor()
	
	if change_pos && act:
		act.global_position = exit.exit_pos
	if change_direction && vel:
		vel.overwrite_direction(
			Vector2i(
				-1 if exit.facing_left else 1,
				0
			)
		)
#endregion
