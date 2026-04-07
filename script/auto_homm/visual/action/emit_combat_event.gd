class_name teVisualActionEmitCombatEvent extends teVisualActionBase


var event: teCombatEventBase


func is_instant() -> bool:
	return true


func dbg_dump() -> String:
	return super.dbg_dump() + event.get_script().get_global_name()
