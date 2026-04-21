@tool
class_name teUnitSet extends Resource


@export var units: Dictionary[StringName, teUnitDefinition]


func get_definition(unit_uid: StringName) -> teUnitDefinition:
	return units[unit_uid]
