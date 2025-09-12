class_name CombatTurnContext


var observed_state: CombatState
var services: CombatServices


func _init(_state: CombatState, _services: CombatServices = null) -> void:
	observed_state = _state
	services = _services
