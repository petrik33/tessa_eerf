@tool
class_name CombatActions

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")
	
static func move(context: CombatContext, id_path: PackedInt64Array) -> CombatActionMove:
	return CombatActionMove.new(
		context.state().current_unit_idx(),
		context.navigation().path(id_path)
	)
