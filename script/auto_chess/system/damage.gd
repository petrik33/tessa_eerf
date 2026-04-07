@tool
class_name acDamage


func _init() -> void:
	Utils.assert_static_lib()


enum Type {
	Physical,
	Magical,
	Pure
}


static func resolve(damage: acDamageEvent, state: acBattleState):
	pass
