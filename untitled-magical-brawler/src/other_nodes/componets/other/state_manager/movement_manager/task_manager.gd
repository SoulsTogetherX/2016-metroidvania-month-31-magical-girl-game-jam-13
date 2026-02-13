@tool
class_name TaskManager extends StateManager


#region Constants
const VELOCITY_NAME := &"__velocity_component__"
#endregion


#region External Variables
@export_group("Modules")
@export var velocity: VelocityComponent
#endregion



#region Virtual Variables
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super()

func _validate_property(property: Dictionary) -> void:
	if property.name == &"args":
		property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion


#region Private Methods (Helper)
func _update_states() -> void:
	_stored_states.clear()
	
	for child : Node in get_children():
		if child is ManagedTaskState:
			_stored_states.set(
				child.state_id(),
				child
			)
#endregion


#region Public Methods (Helper)
func get_args() -> Dictionary:
	return args.merged(
		{
			VELOCITY_NAME: velocity
		}
	)
#endregion
