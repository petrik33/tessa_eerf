class_name teVisualWriting extends Node


func _init() -> void:
	Utils.assert_static_lib()


enum ComboTrigger {
	ALWAYS,
	NO_ATTACK_MODIFIER,
	ATTACK_MODIFIED
}


enum AttackKind {
	MELEE,
	PROJECTILE,
	CAST
}


enum SkillVisual {
	VFX,
	NONE
}


enum UnitSocket {
	TARGET,
	ORIGIN
}
