class_name CombatHotSeatController extends CombatController


@export var controlled_armies: Array[String]


func is_turn_controlled(turn_handle: CombatHandle):
	var army_id := turn_handle.id()
	return controlled_armies.has(army_id)
