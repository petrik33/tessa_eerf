class_name CombatConfig extends Resource

@export var grid: HexGridBase:
	set(value):
		grid = value
		emit_changed()
	
@export var units: Array[CombatUnit]:
	set(value):
		units = value
		emit_changed()
	
@export var seed: int = 42:
	set(value):
		seed = value
		emit_changed()
