@tool
class_name Player extends CombatEntity


#region External Variables
@export_group("Effect")
@export var effects : Array[BaseEffect]:
	set(val):
		for i : int in range(val.size()):
			if !val[i]:
				val[i] = FlatHealthEffect.new()
		effects = val
#endregion


#region Onready Variables
@onready var _ability_cache: AbilityCacheModule = %AbilityCacheModule
@onready var _camera_lead: CameraLead = $CameraLead

@onready var _context_task: Node = %UpdateContextTask
@onready var _knockback_component: KnockbackComponent = %KnockbackComponent
#endregion


#region Public Variables
var no_spike_hit : bool = false
#endregion



#region Virtual Methods
func _ready() -> void:
	if Engine.is_editor_hint():
		return
	reset_camera_lead_direction()
	update_camera_lead_y()
#endregion


#region Ability Methods
func has_ability(type : AbilityData.ABILITY_TYPE) -> bool:
	return _ability_cache.has_ability(type)
func register_ability(type : AbilityData.ABILITY_TYPE) -> void:
	_ability_cache.register_ability(type)
#endregion


#region Camera Lead Methods
func get_camera_lead() -> Marker2D:
	return _camera_lead

func reset_camera_lead_direction() -> void:
	if _camera_lead == null:
		return
	_camera_lead.set_direction(Vector2.ZERO)
func set_camera_lead_direction(direction : Vector2) -> void:
	if _camera_lead == null:
		return
	_camera_lead.set_direction(direction)
func update_camera_lead_y() -> void:
	if _camera_lead == null:
		return
	_camera_lead.set_y_pos(global_position.y)


func set_camera_lead_x_bias(val : float) -> void:
	if _camera_lead == null:
		return
	_camera_lead.set_x_bias(val)
func set_camera_lead_y_bias(val : float) -> void:
	if _camera_lead == null:
		return
	_camera_lead.set_y_bias(val)
func set_camera_flat_y_offset(val : float) -> void:
	if _camera_lead == null:
		return
	_camera_lead.set_flat_y_offset(val)


func force_current_offset() -> void:
	if _camera_lead == null:
		return
	_camera_lead.y_pos = global_position.y
	_camera_lead.force_current_offset()

func toggle_player(toggle : bool) -> void:
	_context_task.accept_input = toggle

func _on_spike_detect(
	_body_rid: RID, _body: Node2D, _body_shape_index: int,
	_local_shape_index: int
) -> void:
	if no_spike_hit:
		return
	if _status_effect_receiver.has_effect_type(
		StatusEffect.STATUS_TYPE.STUN
	):
		return
	
	var status := StatusEffect.new()
	status.type = StatusEffect.STATUS_TYPE.STUN
	status.duration = 0.3
	_status_effect_receiver.apply_effect(
		status
	)
	_knockback_component.enact_knockback(
		-(_velocity_module.velocity * 0.5).minf(400.0),
		true, true
	)
#endregion
