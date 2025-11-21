@tool
class_name CombatVisualUnit extends CombatVisualUnitBase


@export var physical_node: Node2D


func get_physical_node() -> Node2D:
	return physical_node if physical_node != null else self


func execute(action: CombatVisualUnitActionBase):
	if not has_method(action.id):
		executed.emit()
		return
	await call(action.id, action)
