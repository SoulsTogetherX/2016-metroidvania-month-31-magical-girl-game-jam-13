extends HSMModule


#region External Variables
@export_group("Modules")
@export var task : TaskNode
#endregion



#region Public Methods (State Change)
func start_module(act : Node, ctx : HSMContext) -> void:
	var entity : BaseEntity = act
	entity.start_task(task, {
		"jump_offset" : Vector2(
			800 * -ctx.get_value(GlobalLabels.hsm_context.VAL_H_DIR),
			-800
		)
	})
func end_module(act : Node, _ctx : HSMContext) -> void:
	var entity : BaseEntity = act
	entity.end_task(task)
#endregion
