class_name CombatUiLeftMarker extends Control


@export var stack_size_label: Label


func set_stack_size(count: int):
	stack_size_label.text = "%d" % [count]


func set_team(idx: int):
	pass
