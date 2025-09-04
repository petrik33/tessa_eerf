class_name CombatArmyHandle extends CombatHandle

@export var idx: int


func id() -> String:
	return "army:%d" % [idx]


func _init(_idx: int = -1) -> void:
	idx = _idx
