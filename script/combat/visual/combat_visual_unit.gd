@tool
class_name CombatVisualUnit extends CombatVisualUnitBase


@export var physical_node: Node2D
@export var action_components: Array[CombatVisualUnitActionComponent]


func get_physical_node() -> Node2D:
	return physical_node if physical_node != null else self


func execute(action: CombatVisualUnitActionBase):
	if not has_method(action.id):
		executed.emit()
		return
	await call(action.id, action)


func _ready() -> void:
	for component in action_components:
		component.executed.connect(_handle_action_executed)


func _handle_action_executed():
	executed.emit()
