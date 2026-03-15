extends Node


#region Constants (Save File)
const FILE_FOLDER := "user://kira-kira-saves"
const DEFAULT_FILE_NAME := "you-hacker"
const SAVE_NAME := "save"
#endregion


#region Enums
enum SAVE_KEYS {
	ROOM,
	ABLITIES,
	POSITION	,
	EVENTS	
}
#endregion


#region Private Variables
var _loaded_data : Dictionary
#endregion



func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			gather_save_file(DEFAULT_FILE_NAME)


#region Private Methods
func _request_save() -> void:
	var nodes := get_tree().get_nodes_in_group(GlobalLabels.groups.SAVEABLE_GROUP_NAME)
	
	for save_node : Node in nodes:
		if save_node.has_method("_request_save"):
			save_node._request_save()
func _request_load() -> void:
	var nodes := get_tree().get_nodes_in_group(GlobalLabels.groups.SAVEABLE_GROUP_NAME)
	
	for save_node : Node in nodes:
		if save_node.has_method("_request_load"):
			save_node._request_load()
#endregion



#region Public Methods (FileAccess)
func load_file(save_name : String) -> void:
	var file_path := "%s/%s.save" % [FILE_FOLDER, save_name]
	
	_loaded_data.clear()
	var err := FileHandler.read_binary_file(
		_loaded_data,
		file_path
	)
	if err != OK:
		push_error("Cannot read data from filepath '%s'" % file_path)
	_request_load()

func gather_save_file(save_name : String) -> void:
	_request_save()
	save_file(save_name)
func save_file(save_name : String) -> void:
	var file_path := "%s/%s.save" % [FILE_FOLDER, save_name]
	
	var err := FileHandler.store_binary_file(
		_loaded_data.duplicate(),
		file_path,
		true
	)
	if err != OK:
		push_error("Cannot save data to filepath '%s'" % file_path)
#endregion


#region Public Methods (Helper)
func set_key(key : SAVE_KEYS, val : Variant) -> void:
	_loaded_data.set(key, val)
func get_key(key : SAVE_KEYS) -> Variant:
	return _loaded_data.get(key, null)

func clear_save_file(save_name : String) -> void:
	_loaded_data.clear()
	save_file(save_name)
#endregion
