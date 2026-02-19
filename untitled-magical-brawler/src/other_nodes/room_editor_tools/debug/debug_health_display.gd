@tool
class_name DebugHealthDisplayLabel extends Label


#region Constants
const FONT_WIDTH := Constants.DEBUG_FONT_WIDTH
#endregion


#region External Variables
@export_group("Modules")
@export var health_module : HealthComponent:
	set(val):
		if val == health_module:
			return
		
		if health_module:
			health_module.max_health_changed.disconnect(_update_health_display)
			health_module.health_changed.disconnect(_update_health_display)
		health_module = val
		if health_module:
			health_module.max_health_changed.connect(_update_health_display.unbind(1))
			health_module.health_changed.connect(_update_health_display.unbind(1))
			_update_health_display()
			return
		_clear_health()


@export_group("Other")
@export var follow : BaseEntityManager:
	set(val):
		if val == follow:
			return
		follow = val
		
		set_physics_process(follow != null)
		if !follow:
			_reposition_orign()

@export var follow_offset : Vector2:
	set(val):
		if val == follow_offset:
			return
		follow_offset = val
#endregion



#region External Variables
func _init() -> void:
	top_level = true
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	add_theme_font_size_override("font_size", FONT_WIDTH)

func _ready() -> void:
	set_physics_process(follow != null)
	if follow:
		_reposition_to_follow()
	else:
		_reposition_orign()
	
	if health_module:
		_update_health_display()
	else:
		_clear_health()

func _physics_process(_delta: float) -> void:
	_reposition_to_follow()
#endregion


#region External Variables
func _reposition_to_follow() -> void:
	global_position = follow_offset + follow.get_actor_positon()
	global_position.x -= size.x * 0.5
func _reposition_orign() -> void:
	global_position = Vector2.ZERO

func _update_health_display() -> void:
	text = "%d/%d" % [health_module.get_health(), health_module.get_max_health()]
func _clear_health() -> void:
	text = "N/A"
	
#endregion
