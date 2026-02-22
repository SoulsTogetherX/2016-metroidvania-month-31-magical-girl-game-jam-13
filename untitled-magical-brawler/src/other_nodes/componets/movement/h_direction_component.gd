@tool
class_name HDirectionComponent extends Node


#region External Variables
@export_group("Settings")
@export var disable : bool:
	set(val):
		if val == disable:
			return
		disable = val
		
		if !disable:
			adjust_piviot()

@export_group("Modules")
@export var velocity_module : VelocityComponent:
	set(val):
		if val == velocity_module:
			return
		
		if velocity_module:
			velocity_module.hor_velocity_changed.disconnect(
				adjust_piviot
			)
		velocity_module = val
		if velocity_module:
			velocity_module.hor_velocity_changed.connect(
				adjust_piviot
			)

@export_group("Other")
@export var actor : BaseEntity
#endregion


func adjust_piviot() -> void:
	if disable:
		return
	
	actor.change_direction(
		velocity_module.facing_left(), false
	)
