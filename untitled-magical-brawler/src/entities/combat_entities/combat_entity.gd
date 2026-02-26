@tool
@abstract
class_name CombatEntity extends BaseEntity


#region Export Variables
@export_group("Debug")
@export_subgroup("Health")
@export var display_health : bool = false:
	set(val):
		if val == display_health:
			return
		display_health = val
		
		_refresh_health_display()
@export var display_health_offset : Vector2:
	set(val):
		if val == display_health_offset:
			return
		display_health_offset = val
		
		if is_node_ready() && _health_display:
			_health_display.follow_offset = display_health_offset
#endregion


#region Private Export Variables
@export_group("Hidden Exports")
@export var _health_module: HealthComponent
#endregion


#region Private Variables
var _health_display : DebugHealthDisplayLabel
#endregion



#region Virtual Methods
func _validate_property(property: Dictionary) -> void:
	super(property)
	if property.name in [&"_health_module"]:
		if owner != null:
			property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion


#region Private Methods (Toggle)
func _refresh_debugs() -> void:
	super()
	_refresh_health_display()
func _refresh_health_display() -> void:
	if !is_node_ready():
		return
	
	if display_health:
		if !_health_display:
			_health_display = DebugHealthDisplayLabel.new()
			add_child(_health_display)
		
		_health_display.health_module = _health_module
		_health_display.follow = self
		_health_display.follow_offset = display_health_offset
		return
	
	if _health_display:
		_health_display.queue_free()
		_health_display = null
#endregion


#region Public Methods (Checks)
func has_health() -> bool:
	return _health_module != null
#endregion


#region Public Methods (Health)
func get_health_component() -> HealthComponent:
	return _health_module

func get_health() -> int:
	if !_health_module:
		return 0
	return _health_module.get_health()
func get_max_health() -> int:
	if !_health_module:
		return 0
	return _health_module.get_max_health()

func inflict_damage(delta : int) -> void:
	if !_health_module:
		return
	_health_module.damage(delta)
func heal_damage(delta : int) -> void:
	if !_health_module:
		return
	_health_module.heal(delta)
#endregion
