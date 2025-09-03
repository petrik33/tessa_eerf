class_name CombatActionAppendToTurnQueue extends CombatActionBase

@export var unit_handle: CombatUnitHandle

func _init(_unit_handle: CombatUnitHandle = null) -> void:
	unit_handle = _unit_handle
