extends HSMModule


#region External Variables
@export_group("Animations")
@export var behavioral_tree : BeehaveTree

@export_group("Settings")
@export var enable_on_enter : bool = true
#endregion



#region Public Methods (State Change)
func _ready() -> void:
	behavioral_tree.enabled = !enable_on_enter
#endregion


#region Public Methods (State Change)
func start_module(_act : Node, _ctx : HSMContext) -> void:
	behavioral_tree.enabled = enable_on_enter
func end_module(_act : Node, _ctx : HSMContext) -> void:
	behavioral_tree.enabled = !enable_on_enter
#endregion
