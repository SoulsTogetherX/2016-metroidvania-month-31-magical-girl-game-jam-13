@abstract
class_name HSMModule extends Node



#region Module Change
@abstract
func start_module(actor : Node, context : HSMContext) -> void
@abstract
func end_module(actor : Node, context : HSMContext) -> void
#endregion
