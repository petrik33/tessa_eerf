@tool
class_name CombatVisualUnitBase extends Node2D


signal executed()


func get_physical_node() -> Node2D:
	assert(false, "not implemented")
	return null


func execute(action: CombatVisualUnitActionBase):
	assert(false, "not implemented")


func _emit_executed():
	executed.emit()
