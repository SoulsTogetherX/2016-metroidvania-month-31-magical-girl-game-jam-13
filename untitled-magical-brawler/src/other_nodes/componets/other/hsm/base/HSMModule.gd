@abstract
class_name HSMModule extends Node



#region Module Change
@abstract
func start_module(act : Node, ctx : HSMContext) -> void
@abstract
func end_module(act : Node, ctx : HSMContext) -> void
#endregion
