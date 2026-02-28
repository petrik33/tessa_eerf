class_name teVisualActionBase extends Resource


func dbg_dump() -> String:
	var props := []
	for p in get_property_list():
		if not (p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE):
			continue
		if not (p.usage & PROPERTY_USAGE_STORAGE):
			continue
		var name = p.name
		var value = get(name)
		if value == null:
			continue
		if value is Array and value.is_empty():
			continue
		if value is int and value == -1:
			continue
		props.append("%s=%s" % [name, value])
	return "%s(%s)" % [_get_clean_class_name(), ", ".join(props)]


func _get_clean_class_name() -> String:
	if get_script() == null:
		return "Unknown"
	return get_script().get_global_name()
