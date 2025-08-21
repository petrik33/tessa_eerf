@tool
class_name CombatActions

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")
	
static func move(runtime: CombatRuntime, id_path: PackedInt64Array) -> CombatActionMove:
	return CombatActionMove.new(
		runtime.state().current_unit_idx(),
		runtime.navigation().path(id_path)
	)
