class_name Context extends Resource


var fields: Dictionary[StringName, Variant] = {}


func add(key: StringName, value: Variant = true):
	fields[key] = value


func has(key: StringName) -> bool:
	return fields.has(key)


func read(key: StringName) -> Variant:
	return fields[key]


func read_or(key: StringName, default: Variant) -> Variant:
	if has(key):
		return read(key)
	else:
		return default


func overwrite(key: StringName, value: Variant):
	if not has(key):
		return
	fields[key] = value
