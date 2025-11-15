class_name CombatArmyHandle extends CombatHandle

@export var idx: int


func id() -> String:
	return "army:%d" % [idx]


func _init(_idx: int = -1) -> void:
	idx = _idx


static func from_id(_id: String) -> CombatArmyHandle:
	var regex := RegEx.new()
	regex.compile("^army:(\\d+)$")
	var regex_match := regex.search(_id)
	if not regex_match:
		return null

	return CombatArmyHandle.new(int(regex_match.get_string(1)))
