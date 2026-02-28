extends HSMModule


#region External Variables
@export_group("Settings")
@export var task : TaskNode
#endregion



#region Public Methods (State Change)
func start_module(actor : Node, context : HSMContext) -> void:
	var act : BaseEntity = actor
	act.start_task(task, {
		&"move_dir" : context.get_value.bind(
			GlobalLabels.hsm_context.VAL_H_DIR
		)
	})
func end_module(actor : Node, _context : HSMContext) -> void:
	var act : BaseEntity = actor
	act.end_task(task)
#endregion
