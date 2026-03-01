extends HSMBranch


#region External Variables
@export_group("Tasks")
@export var moving_point_task : TaskNode

@export_group("Other")
@export var forgiveness : float = 100
@export var purse_lingur : Timer
#endregion



#region Virtual Methods
func _ready() -> void:
	purse_lingur.timeout.connect(_stop_pursing)
#endregion


#region Public Virtual Methods
func action_started(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_SPOTTED_PLAYER:
			purse_lingur.stop()
func action_finished(action_name : StringName) -> void:
	match action_name:
		GlobalLabels.hsm_context.ACT_SPOTTED_PLAYER:
			purse_lingur.start()
#endregion


#region Private Methods
func _stop_pursing() -> void:
	var ctx := get_context()
	ctx.set_action(
		GlobalLabels.hsm_context.ACT_PURSUING_PLAYER, false
	)
#endregion


#region Public State Change Methods
func enter_state(act : Node, _ctx : HSMContext) -> void:
	var enemy : Enemy = act
	enemy.get_target_point = func() -> Vector2: return Global.player.global_position
	enemy.start_task(
		moving_point_task,
		{ &"get_target_point" : enemy.get_target_point }
	)
func exit_state(act : Node, _ctx : HSMContext) -> void:
	var entity : CombatEntity = act
	entity.end_task(
		moving_point_task
	)
#endregion
