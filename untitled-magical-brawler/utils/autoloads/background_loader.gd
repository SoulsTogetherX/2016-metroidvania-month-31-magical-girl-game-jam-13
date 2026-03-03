extends Node


#region Private Variables
var _tasks : Array[Task] = []
#endregion



#region Virtual Methods
func _process(_delta: float) -> void:
	for task : Task in _tasks:
		task.process_task()
#endregion


#region Private Methods
func _remove_task(task : Task) -> void:
	_tasks.erase(task)
#endregion


#region Public Methods
func request_resource(
	resource_path : StringName, type_hint: String = "",
	on_sig : Signal = Signal(),
	use_sub_threads : bool = false,
	cache_mode: ResourceLoader.CacheMode = ResourceLoader.CacheMode.CACHE_MODE_REUSE
) -> Task:
	if ResourceLoader.load_threaded_request(
		resource_path, type_hint,
		use_sub_threads, cache_mode
	) != OK:
		return null
	
	var task = Task.new(resource_path, type_hint, on_sig)
	task.finished.connect(_remove_task.bind(task))
	_tasks.append(task)
	
	return task
#endregion


#region Innner Class
class Task:
	#region Signals
	signal finished
	#endregion
	
	#region Private Variables
	var _on_sig : Signal
	var _resource_path : String
	
	var _finished : bool = false
	var _resource : Resource = null
	#endregion
	
	#region Virtual Methods
	func _init(
		resource_path : String, type_hint : String, on_sig : Signal
	) -> void:
		assert(
			ResourceLoader.exists(resource_path, type_hint),
			"Attempted to load nonexistent resource"
		)
		
		_resource_path = resource_path
		_on_sig = on_sig
		if !_on_sig.is_null():
			_on_sig.connect(process_task)
	#endregion
	
	#region Public Methods
	func process_task() -> void:
		var status := ResourceLoader.load_threaded_get_status(
			_resource_path
		)
		
		match status:
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
				return
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
				_finished = true
				_resource = null
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
				_finished = true
				_resource = null
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
				_finished = true
				_resource = ResourceLoader.load_threaded_get(_resource_path)
		
		finished.emit()
		if !_on_sig.is_null():
			_on_sig.disconnect(process_task)
	
	func is_finished() -> bool:
		return _finished
	
	func get_resource() -> Resource:
		if _finished:
			return _resource
		return ResourceLoader.load_threaded_get(_resource_path)
	func get_resource_path() -> String:
		return _resource_path
#endregion
