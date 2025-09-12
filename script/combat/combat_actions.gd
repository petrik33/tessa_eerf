@tool
class_name CombatActions


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func move(state: CombatState, services: CombatServices, id_path: PackedInt64Array) -> CombatActionMove:
	return CombatActionMove.new(
		state.current_unit_handle(),
		services.navigation.path(id_path)
	)
