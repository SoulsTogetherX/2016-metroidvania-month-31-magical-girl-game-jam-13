class_name GlobalCamera extends Camera2D


#region OnReady Variables
@onready var _phantom_camera_host: PhantomCameraHost = %PhantomCameraHost
@onready var _noise_emitter_2d: PhantomCameraNoiseEmitter2D = %NoiseEmitter2D
#endregion



#region Virtual Methods
func _ready() -> void:
	Engine.time_scale = 1.0
#endregion


#region Public Methods
func get_host() -> PhantomCameraHost:
	return _phantom_camera_host
func get_active_pcam() -> PhantomCamera2D:
	return _phantom_camera_host.get_active_pcam()
#endregion



#region Effects
static func create_noise(
	amplitude : float = 100.0, frequency : float = 10
) -> PhantomCameraNoise2D:
	var ret := PhantomCameraNoise2D.new()
	ret.amplitude = amplitude
	ret.frequency = frequency
	
	return ret
func screen_shake(
	noise : PhantomCameraNoise2D = null,
	duration : float = 0.3,
	growth_time : float = 0.0,
	delay_time : float = 0.3
) -> void:
	if noise == null:
		return
	
	_noise_emitter_2d.duration = duration
	_noise_emitter_2d.growth_time = growth_time
	_noise_emitter_2d.decay_time = delay_time
	_noise_emitter_2d.noise = noise
	_noise_emitter_2d.emit()
func freeze_frame(t_scale : float = 1.0, duration : float = 0.1) -> void:
	Engine.time_scale = t_scale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
#endregion
