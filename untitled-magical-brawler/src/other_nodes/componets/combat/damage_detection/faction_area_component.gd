@abstract
@tool
class_name FactionAreaComponent extends Area2D


#region External Variables
@export_group("Settings")
@export var shape : Shape2D:
	set(val):
		if val == shape:
			return
		shape = val
		
		_refresh_collider()
@export var disabled : bool:
	set(val):
		if val == disabled:
			return
		disabled = val
		
		if is_node_ready():
			_collider.disabled = val

@export_group("Faction")
@export_flags_2d_physics var faction: int = Constants.COLLISION.PLAYER:
	set(val):
		if val == faction:
			return
		faction = val
		
		_refresh_faction()

@export_group("Destroy")
@export_range(0, 10, 0.01, "or_greater") var duration : float = 0.0
#endregion


#region Private Variables
var _collider : CollisionShape2D
#endregion



#region Virtual Methods
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_READY:
			_refresh_faction()
			_refresh_collider()
			
			if Engine.is_editor_hint():
				return
			if duration > 0:
				destroy_box(duration)

func _validate_property(property: Dictionary) -> void:
	if property.name in [&"collision_layer", &"collision_mask"]:
		property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion


#region Custom Virtual Methods
func _refresh_faction() -> void:
	collision_mask = faction
	collision_layer = faction
#endregion


#region Private Methods
func _refresh_collider() -> void:
	if _collider:
		_collider.queue_free()
		_collider = null
	
	if shape:
		_collider = CollisionShape2D.new()
		_collider.shape = shape
		_collider.disabled = disabled
		add_child(_collider)
#endregion


#region Public Methods
func destroy_box(delay : float = 0.0) -> void:
	if is_zero_approx(delay):
		queue_free()
		return
	get_tree().create_timer(delay).timeout.connect(queue_free)
#endregion
