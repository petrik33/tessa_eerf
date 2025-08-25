@tool
@icon("res://editor/icons/hex_space.svg")
class_name HexSpace extends Node2D

signal changed()

@export var layout: HexLayout:
	set(value):
		if layout != null:
			layout.changed.disconnect(_update)
		layout = value
		if layout != null:
			layout.changed.connect(_update)
		_update()

func is_configured() -> bool:
	return layout != null

func _update():
	update_configuration_warnings()
	changed.emit()

func _get_configuration_warnings() -> PackedStringArray:
	if not is_configured():
		return ["Hex layout not assigned"]
	return []
