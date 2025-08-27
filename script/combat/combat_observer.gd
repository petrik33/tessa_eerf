class_name CombatObserver extends Node

@export var combat: Combat

func runtime() -> CombatRuntime:
	return _runtime
	
var _runtime: CombatRuntime

func _on_combat_started():
	_runtime = combat.runtime()

func _on_combat_finished():
	_runtime = null
