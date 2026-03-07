class_name teCombatSession extends Node


signal finished(final_state: teCombatState)


@export var movie: teCombatMovie
@export var simulation_runner: teCombatSimulationRunner
@export var max_simulation_steps := 35


var simulation_id := -1
var combat_services: teCombatServices
var paused := false


func running() -> bool:
	return simulation_id != -1


func start(combat: teCombatSetup, rule_set: teCombatRuleSet, unit_roster: teCombatUnitRoster):
	if running():
		return
	combat_services = teCombatServices.new(combat)
	var initial_state = rule_set.rules.initialize(
		combat,
		rule_set.units,
		unit_roster
	)
	simulation_id = simulation_runner.register(
		rule_set.rules,
		combat_services,
		initial_state
	)
	progress()


func progress():
	var simulation := simulation_runner.simulation(simulation_id)
	while not paused:
		var turn_log := simulation_runner.step(simulation_id)
		await movie.run(turn_log)
		if simulation.steps_made() >= max_simulation_steps or simulation.finished():
			finished.emit(simulation.current_state)
			return
		


func pause():
	if paused:
		return
	paused = true


func unpause():
	if not paused:
		return
	paused = false
	progress()


func stop():
	pause()
	var simulation := simulation_runner.unregister(simulation_id)
	finished.emit(simulation.current_state)
	simulation_id = -1
