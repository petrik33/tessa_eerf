class_name teCombatCommands


func _init() -> void:
	Utils.assert_static_lib()


static func attack(unit_id: int, target_id: int) -> teCombatCommandAttack:
	var command := teCombatCommandAttack.new()
	command.unit_id = unit_id
	command.target_id = target_id
	return command

static func wait() -> teCombatCommandWait:
	var command := teCombatCommandWait.new()
	return command

static func start_combat() -> teCombatCommandStart:
	return teCombatCommandStart.new()

static func skip_hero_turn() -> teCombatCommandSkipHeroTurn:
	return teCombatCommandSkipHeroTurn.new()

static func cast_skill(unit_id: int, target: teCombatTargetBase) -> teCombatCommandCastSkill:
	var command := teCombatCommandCastSkill.new()
	command.unit_id = unit_id
	command.target = target
	return command
