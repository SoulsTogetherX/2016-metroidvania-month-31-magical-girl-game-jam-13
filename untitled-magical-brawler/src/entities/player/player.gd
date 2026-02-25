@tool
class_name Player extends BaseEntity


#region OnReady Variables
# Task Manager Tasks
@onready var _task_manager: TaskManager = %TaskManager

# Important Tasks
@onready var _gravity_task: TaskNode = %GravityTask
@onready var _velocity_apply_task: TaskNode = %VelocityApplyTask
@onready var _update_cache_task: TaskNode = %UpdateCacheTask

# Caches
@onready var _ability_cache: AbilityCacheModule = %AbilityCacheModule
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
		_task_manager.task_begin(
			_update_cache_task,
			{
				&"actor": self
			}
		)
		return
	_task_manager.task_end(_update_cache_task)
#endregion


#region Public Methods
func has_ability(ability : AbilityData) -> bool:
	return _ability_cache.has_ability_data(ability)
func register_ability(ability : AbilityData) -> void:
	if has_ability(ability):
		return
	_ability_cache.register_ability(ability)
#endregion


#region Private Methods
func _task_settup() -> void:
	_task_manager.task_begin(_gravity_task)
	_task_manager.task_begin(
		_velocity_apply_task,
		{
			&"actor": self
		}
	)
#endregion
