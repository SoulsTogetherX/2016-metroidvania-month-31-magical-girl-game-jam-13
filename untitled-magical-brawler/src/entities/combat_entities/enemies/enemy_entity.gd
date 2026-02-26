@tool
class_name Enemy extends CombatEntity


#region OnReady Variables
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _status_effect_receiver: StatusEffectReceiver = %StatusEffectReceiver
@onready var _task_manager: VelocityTaskManager = %TaskManager
#endregion


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	(%Blackboard as Blackboard).set_value(
		GlobalLabels.bh_blackboard.INTEREST_POINT,
		global_position
	)


#region Public Methods
func play_animation(animation_name : StringName) -> void:
	_animation_player.play(animation_name)
func is_animation_playing() -> bool:
	return _animation_player.is_playing()

func has_status_effect(type : StatusEffect.STATUS_TYPE) -> bool:
	return _status_effect_receiver.has_effect_type(type)

func start_task(
	node : TaskNode, args : Dictionary = {},
	overwrite : bool = true
) -> void:
	_task_manager.task_begin(node, args, overwrite)
func end_task(node : TaskNode) -> void:
	_task_manager.task_end(node)
#endregion
