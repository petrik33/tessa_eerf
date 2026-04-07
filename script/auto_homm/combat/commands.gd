class_name teCombatCommands


func _init() -> void:
	Utils.assert_static_lib()


static func unit_attack(unit_id: int, target_id: int) -> teCombatCommandUnitAttack:
	var command := teCombatCommandUnitAttack.new()
	command.unit_id = unit_id
	command.target_id = target_id
	return command

static func unit_move(unit_id: int, path: Array[Vector2i]) -> teCombatCommandUnitMove:
	var command := teCombatCommandUnitMove.new()
	command.move_path = path
	command.unit_id = unit_id
	return command

static func start_combat() -> teCombatCommandStart:
	return teCombatCommandStart.new()

static func skip_hero_turn() -> teCombatCommandSkipHeroTurn:
	return teCombatCommandSkipHeroTurn.new()
