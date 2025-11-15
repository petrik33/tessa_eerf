class_name CombatUnitHandle extends CombatHandle

@export var idx: int
@export var army_idx: int


func id() -> String:
	return "unit:%d_army%d" % [idx, army_idx]


func _init(_idx := -1, _army_idx := -1) -> void:
	idx = _idx
	army_idx = _army_idx


static func from_id(_id: String) -> CombatUnitHandle:
	var regex := RegEx.new()
	regex.compile("^unit:(\\d+)_army(\\d+)$")
	var regex_match := regex.search(_id)
	if not regex_match:
		return null
	var _idx = int(regex_match.get_string(1))
	var _army_idx = int(regex_match.get_string(2))
	return CombatUnitHandle.new(_idx, _army_idx)
