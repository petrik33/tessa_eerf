class_name acBattleSimulation extends Node


@export var rules: acBattleRules


signal tick(updated_state: acBattleState)


var state: acBattleState
var time := 0.0


func _ready() -> void:
	set_physics_process(false)


func start(initial_state: acBattleState):
	if rules == null:
		return
	time = 0.0
	state = initial_state.duplicate(true)
	set_physics_process(true)


func stop():
	set_physics_process(false)
	state = null
	time = 0.0


func pause():
	if state == null:
		return
	set_physics_process(false)


func resume():
	if state == null:
		return
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	rules.apply(state, delta)
	time += delta
	tick.emit(state)
