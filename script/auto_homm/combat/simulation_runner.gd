class_name teCombatSimulationRunner extends Node


var rules: teCombatRules
var services: teCombatServices
var registered: Dictionary[int, teCombatSimulation] = {}
var max_id := 0


func simulation(id: int) -> teCombatSimulation:
	return registered[id]


func register(rules: teCombatRules, services: teCombatServices, initial_state: teCombatState) -> int:
	var combat_simulation := teCombatSimulation.new(initial_state)
	var simulation_id := max_id
	max_id += 1
	registered[simulation_id] = combat_simulation
	return simulation_id


func unregister(id: int) -> teCombatSimulation:
	var combat_simulation := registered[id]
	registered.erase(id)
	return combat_simulation


func step(id: int) -> teCombatEventLog:
	var combat_simulation := simulation(id)
	var next_command := rules.progress(combat_simulation.current_state, services)
	var turn_log := rules.process(combat_simulation.current_state, next_command, services)
	combat_simulation.progress(turn_log)
	return turn_log
