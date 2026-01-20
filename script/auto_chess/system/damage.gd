@tool
class_name acDamage


func _init() -> void:
	assert(false, "Can't be constructed")


enum Type {
	Physical,
	Magical,
	Pure
}


static func resolve(damage: acDamageEvent, state: acBattleState):
	pass
