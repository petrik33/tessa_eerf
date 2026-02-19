class_name teCombatSimulationRunner extends Node


signal turn_progressed(id: int, log: teCombatEventLog)


var registered: Dictionary[int, teCombatSimulation] = {}
var running: Dictionary[int, bool] = {}
var max_id := 0


func get_simulation(id: int) -> teCombatSimulation:
	return registered[id]


func start(rules: teCombatRules, setup: teCombatSetup) -> int:
	var simulation := teCombatSimulation.new()
	simulation.rules = rules
	simulation.services = teCombatServices.new(setup)
	simulation.current_state = rules.initialize(setup)
	var simulation_id := max_id
	max_id += 1
	registered[simulation_id] = simulation
	running[simulation_id] = true
	return simulation_id


func pause(id: int):
	running[id] = false


func stop(id: int) -> teCombatSimulation:
	var simulation := registered[id]
	registered.erase(id)
	running.erase(id)
	return simulation


func _physics_process(_delta: float):
	for id in registered.keys():
		if running[id]:
			var turn_log = registered[id].progress()
			turn_progressed.emit(id, turn_log)
