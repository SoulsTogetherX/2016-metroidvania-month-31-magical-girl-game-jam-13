class_name DeathHandlerComponent extends DeathHandlerBaseComponent


#region External Variables
@export_group("Modules")
@export var action_cache : ActionCacheComponent

@export_group("Actions")
@export var action_death : StringName = &"dead"
#endregion


#region Private Methods
func _on_death(type : DEATH_TYPE) -> void:
	match type:
		DEATH_TYPE.NORMAL:
			action_cache.set_action(action_death, true)
#endregion
