class_name CombatUiTurnQueueUnitEntry extends Button


@export var underline: Panel


func set_underline_color(color: Color):
	var stylebox := underline.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	stylebox.border_color = color
	underline.add_theme_stylebox_override("panel", stylebox)
