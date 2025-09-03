class_name CombatActionRemoveFromTurnQueue extends CombatActionBase

@export var unit_handle: CombatUnitHandle

func _init(_unit_handle: CombatUnitHandle = null):
	unit_handle = _unit_handle
