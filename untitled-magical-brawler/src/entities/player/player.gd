@tool
extends BaseEntity


#region OnReady Variables
@onready var _action_cache_module: ActionCacheComponent = %ActionCacheModule
@onready var _task: VelocityTaskManager = %TaskManager
#endregion



#region Virtual Methods
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_task_settup()
	toggle_brain(true)
#endregion


#region Public Virtual Methods
func toggle_brain(toggle : bool = true) -> void:
	if toggle:
		_task.task_begin(
			&"Update_Cache_Task",
			{
				&"actor": self
			}
		)
		return
	_task.task_end(&"Update_Cache_Task")
#endregion


#region Private Methods
func _task_settup() -> void:
	_task.task_begin(
		&"Gravity_Task",
		{
			&"on_floor": _action_cache_module.is_action.bind(&"on_floor")
		}
	)
	_task.task_begin(
		&"Velocity_Apply_Task",
		{
			&"actor": self
		}
	)
#endregion
