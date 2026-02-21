extends Node


#region Constants (Save File)
const FILE_FOLDER := "user://saves"
const SAVE_NAME := "save"
#endregion


#region Constants (Save Keys)
const SAVE_POINT_KEY := "__save_point__"
const UPGRADES_KEY := "__upgrades__"
#endregion


#region Public Variables
var _loaded_data : Dictionary
#endregion



#region Public Methods (FileAccess)
func load_file(save_name : String) -> void:
	var file_path := "%s/%s/.save" % [FILE_FOLDER, save_name]
	
	_loaded_data.clear()
	var err := FileHandler.read_binary_file(
		_loaded_data,
		file_path
	)
	if err != OK:
		push_error("Cannot read data from filepath '%s'" % file_path)
func save_file(save_name : String) -> void:
	var file_path := "%s/%s/.save" % [FILE_FOLDER, save_name]
	
	var err := FileHandler.store_binary_file(
		_loaded_data.duplicate(),
		file_path,
		true
	)
	if err != OK:
		push_error("Cannot save data to filepath '%s'" % file_path)
#endregion


#region Public Methods (Data Access)
func get_save_point() -> int:
	return _loaded_data.get(SAVE_POINT_KEY, 0)
func get_upgrades() -> Dictionary:
	return _loaded_data.get(UPGRADES_KEY, {})
#endregion


#region Public Methods (Helper)
func clear_save_file(save_name : String) -> void:
	_loaded_data.clear()
	save_file(save_name)
#endregion
