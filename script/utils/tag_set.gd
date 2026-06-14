class_name TagSet extends Resource


@export var tags: Dictionary[StringName, bool] = {}


func add(tag: StringName, value := true):
	tags[tag] = value


func has(tag: StringName) -> bool:
	return tags.has(tag) and tags[tag]


func is_disabled(tag: StringName) -> bool:
	return tags.has(tag) and not tags[tag]


func disable(tag: StringName):
	if not has(tag):
		return
	tags[tag] = false
