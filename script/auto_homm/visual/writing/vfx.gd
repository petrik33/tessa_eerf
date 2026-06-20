class_name teVisualWritingVfx


func _init() -> void:
	Utils.assert_static_lib()


static func skill(unit_uid: StringName) -> StringName:
	return unit_uid + "_skill"
