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
func _remove_task(_resource : Resource, task : Task) -> void:
	_tasks.erase(task)
#endregion


#region Public Methods
func request_resource(
	resource_path : StringName,
	type_hint: String = "",
	use_sub_threads : bool = false,
	cache_mode: ResourceLoader.CacheMode = ResourceLoader.CacheMode.CACHE_MODE_REUSE
) -> Resource:
	if ResourceLoader.has_cached(resource_path):
		return ResourceLoader.get_cached_ref(resource_path)
	if !ResourceLoader.exists(resource_path, type_hint):
		return null
	
	if ResourceLoader.load_threaded_request(
		resource_path, type_hint,
		use_sub_threads, cache_mode
	) != OK:
		return null
	
	var task = Task.new(resource_path)
	task.finished.connect(_remove_task.bind(task))
	_tasks.append(task)
	
	return await task.finished
#endregion


#region Innner Class
class Task:
	#region Signals
	signal finished(resource : Resource)
	#endregion
	
	#region Private Variables
	var _resource_path : StringName
	#endregion
	
	#region Virtual Methods
	func _init(resource_path : StringName) -> void:
		_resource_path = resource_path
	#endregion
	
	#region Public Methods
	func process_task() -> void:
		var status := ResourceLoader.load_threaded_get_status(
			_resource_path
		)
		
		match status:
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
				pass
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
				finished.emit(null)
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
				finished.emit(null)
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
				finished.emit(
					ResourceLoader.load_threaded_get(_resource_path)
				)
	#endregion
#endregion
