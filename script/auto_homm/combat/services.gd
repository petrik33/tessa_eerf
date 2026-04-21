class_name teCombatServices extends RefCounted


var navigation: HexNavigation


func _init(state: teCombatState):
	navigation = HexNavigation.new(state.map.grid)
	sync(state)


func sync(state: teCombatState):
	navigation.clear_disabled_points()
	for unit_id in state.all_units_id():
		var unit := state.unit(unit_id)
		navigation.set_point_disabled(unit.hex)


func update(event: teCombatEventBase):
	if event is teCombatEventUnitMoved:
		navigation.set_point_disabled(event.path.front(), false)
		navigation.set_point_disabled(event.path.back(), true)
