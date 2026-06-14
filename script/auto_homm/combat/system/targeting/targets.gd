class_name teCombatTargets


func _init() -> void:
	Utils.assert_static_lib()


static func hex(value: Vector2i) -> teCombatTargetBase:
	var target := teCombatTargetHex.new()
	target.hex = value
	return target


static func unit(id: int) -> teCombatTargetBase:
	var target := teCombatTargetUnit.new()
	target.units_id = [id]
	return target


static func units(id: Array[int]) -> teCombatTargetBase:
	var target := teCombatTargetUnit.new()
	target.units_id = id
	return target


static func unit_and_hex(unit_id: int, hex: Vector2i) -> teCombatTargetBase:
	var target := teCombatTargetUnitAndHex.new()
	target.unit_id = unit_id
	target.hex = hex
	return target


static func invalid() -> teCombatTargetBase:
	return teCombatTargetInvalid.new()
