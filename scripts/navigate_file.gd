
class_name NavigatFiles 

var _files: Array = []
var current_file: String = ""
var current_indx: int = 0
var end_of_array = false

func get_files_in_dir(path: String, ext: String) -> void:
	var dir_path = path.get_base_dir() + "/"
	var dir = Directory.new()
	if dir.open(dir_path) == OK:
		dir.list_dir_begin(true , true)
		while true:
			var file_name = dir.get_next()
			if not file_name:
				break
			if dir.current_is_dir() or not file_name.ends_with(ext):
				continue
			_files.append((dir_path + file_name))
		current_file = _files[_files.find(path)]
	else:
		push_error("Error: can't open directory!")

func get_next() -> void:
	current_indx = _files.find(current_file)
	if current_indx != (_files.size() - 1):
		current_file = _files[current_indx + 1]
		end_of_array = false
	else:
		end_of_array = true

func get_back() -> void:
	current_indx = _files.find(current_file)
	if current_indx != 0:
		current_file = _files[current_indx - 1]
		end_of_array = false
	else:
		end_of_array = true
