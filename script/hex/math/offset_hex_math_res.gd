@tool
class_name OffsetHexMathRes extends Resource

@export var impl_script: Script:
	set(value):
		impl_script = value
		_update_impl_instance()
		emit_changed()

func neighbor(hex: Vector2i, direction: int) -> Vector2i:
	assert(_impl_instance != null)
	return _impl_instance.neighbor(hex, direction)
	
	

func to_axial(hex: Vector2i) -> Vector2i:
	assert(_impl_instance != null)
	return _impl_instance.to_axial(hex)

func from_axial(hex: Vector2i) -> Vector2i:
	assert(_impl_instance != null)
	return _impl_instance.from_axial(hex)
	
func is_layout_compatible(layout: HexLayout) -> bool:
	return _impl_instance != null and _impl_instance.is_layout_compatible(layout)
	
func layout_error_message(layout: HexLayout) -> String:
	return _impl_instance.layout_error_message(layout) if _impl_instance != null else "No implementation script assigned."

var _impl_instance: OffsetHexMathImplBase = null

func _init():
	_update_impl_instance()

func _update_impl_instance() -> void:
	if impl_script == null:
		_impl_instance = null
		return

	var instance = impl_script.new()
	if instance is OffsetHexMathImplBase:
		_impl_instance = instance
	else:
		push_error("The provided script must extend OffsetHexMathImplBase")
		_impl_instance = null
