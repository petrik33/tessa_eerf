@tool
class_name SetOperationHexGridBase extends HexGridBase

@export var gridA: HexGridBase:
	set(value):
		if gridA != null:
			gridA.changed.disconnect(emit_changed)
		gridA = value
		if gridA != null:
			gridA.changed.connect(emit_changed)

@export var gridB: HexGridBase:
	set(value):
		if gridB != null:
			gridB.changed.disconnect(emit_changed)
		gridB = value
		if gridB != null:
			gridB.changed.connect(emit_changed)

func is_layout_compatible(layout: HexLayout) -> bool:
	return gridA.is_layout_compatible(layout) and gridB.is_layout_compatible(layout)

func layout_error_message(layout: HexLayout) -> String:
	var errors := PackedStringArray()
	if not gridA.is_layout_compatible(layout):
		errors.append(gridA.layout_error_message(layout))
	if not gridB.is_layout_compatible(layout):
		errors.append(gridB.layout_error_message(layout))
	return "\n".join(errors)
	
func _init(_gridA: HexGridBase = null, _gridB: HexGridBase = null):
	gridA =_gridA
	gridB = _gridB
