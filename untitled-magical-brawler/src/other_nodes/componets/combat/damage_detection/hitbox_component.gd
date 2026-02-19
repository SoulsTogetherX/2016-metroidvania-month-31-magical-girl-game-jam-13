@tool
class_name HitboxComponent extends FactionAreaComponent


#region Signals
signal collision_found
signal max_collisons_reached
#endregion


#region Constants
const DEBUG_COLOR := Color(1, 0, 0, 0.3)
#endregion


#region External Variables
@export_group("Destroy")
@export_range(0, 1, 1, "or_greater") var max_collisions : int = 0

@export_group("Effect")
@export_tool_button("Load Effect Preset") var load_effects_preset = _load_effects_preset
@export var effects : Array[BaseEffect]:
	set(val):
		for i : int in range(val.size()):
			if !val[i]:
				val[i] = FlatHealthEffect.new()
		effects = val
#endregion


#region Private Methods
var _collision_count : int
#endregion



#region Virtual Methods
func _init() -> void:
	monitoring = false
	monitorable = true

func _ready() -> void:
	collision_found.connect(_countdown_collisions)

func _validate_property(property: Dictionary) -> void:
	super(property)
	if property.name in [&"monitoring", &"monitorable"]:
		property.usage &= ~PROPERTY_USAGE_EDITOR
#endregion


#region Custom Virtual Methods
func _refresh_faction() -> void:
	collision_mask = 0
	
	match faction:
		Constants.FACTION.NONE:
			collision_layer = 0
		Constants.FACTION.PLAYER:
			collision_layer = Constants.COLLISION.PLAYER
		Constants.FACTION.ENEMY:
			collision_layer = Constants.COLLISION.ENEMY
		Constants.FACTION.NEUTRAL:
			collision_layer = Constants.COLLISION.PLAYER | Constants.COLLISION.ENEMY
		_:
			collision_layer = 0

func _refresh_collider() -> void:
	super()
	if _collider:
		_collider.debug_color = DEBUG_COLOR
#endregion


#region Private Methods (Helper)
func _load_effects_preset() -> void:
	effects = [
		FlatHealthEffect.new(),
		KnockbackEffect.new()
	]

func _countdown_collisions() -> void:
	_collision_count += 1
	if _collision_count == max_collisions:
		max_collisons_reached.emit()
		queue_free()
#endregion


#region Public Methods
func enact_collision(collide_info : CollisionInfoResource) -> void:
	if !collide_info:
		return
	
	for effect : BaseEffect in effects:
		effect.implement_effect(collide_info)
	collision_found.emit()

func get_collison_number() -> int:
	return _collision_count
func reset_collison_number() -> void:
	_collision_count = 0
#endregion
