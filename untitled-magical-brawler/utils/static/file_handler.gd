class_name FileHandler


#region Static Methods (Manage Binary)
static func store_binary_file(data : Dictionary, file_path : String, create_dir : bool) -> Error:
	var result : Array = _open_file_for_write(file_path, create_dir)
	var err : Error = result[0]
	var file : FileAccess = result[1]
	
	if err != OK:
		return err
	
	file.store_var(data)
	file.close()
	return OK
static func read_binary_file(out_data : Dictionary, file_path : String) -> Error:
	var result : Array = _open_file_for_read(file_path)
	var err : Error = result[0]
	var file : FileAccess = result[1]
	
	if err != OK:
		return err
	
	out_data.assign(file.get_var())
	file.close()
	return OK
#endregion


#region Private Static Methods (Open Files)
static func _open_file_for_write(file_path : String, create_dir : bool) -> Array:
	var err : Error = _check_and_create_directory(file_path, create_dir)
	if err != OK:
		return [err, null]
	
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		return [FileAccess.get_open_error(), null]
	return [OK, file]

static func _open_file_for_read(file_path : String) -> Array:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return [FileAccess.get_open_error(), null]
	return [OK, file]

static func _check_and_create_directory(file_path : String, create : bool) -> Error:
	var dir_path: String = file_path.get_base_dir()
	if DirAccess.dir_exists_absolute(dir_path):
		return OK
	if !create:
		return ERR_CANT_CREATE
	return DirAccess.make_dir_recursive_absolute(dir_path)
#endregion
