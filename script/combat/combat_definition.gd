class_name CombatDefinition extends Resource

@export var grid: HexGridBase:
	set(value):
		grid = value
		emit_changed()
	
@export var armies: Array[CombatArmyDefinition]:
	set(value):
		armies = value
		emit_changed()
	
@export var seed: int = 42:
	set(value):
		seed = value
		emit_changed()


func initializer() -> CombatInitializer:
	return CombatInitializer.new(self)
