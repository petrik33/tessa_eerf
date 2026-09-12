class_name teVisualUnit


func _init() -> void:
	Utils.assert_static_lib()


enum Attack {
	MELEE,
	PROJECTILE,
	CAST
}


enum Skill {
	VFX,
	NONE
}


enum Socket {
	TARGET,
	ORIGIN
}
