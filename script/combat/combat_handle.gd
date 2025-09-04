class_name CombatHandle extends Resource

func id() -> String:
	assert(false, "not implemented")
	return ""


func is_equal(other: CombatHandle) -> bool:
	return other.id() == id()
