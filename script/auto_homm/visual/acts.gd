class_name teVisualActs


func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")


static func name(act: teVisualActBase) -> StringName:
	if act is teVisualActDie:
		return &"die"
	if act is teVisualActMelee:
		return &"melee"
	if act is teVisualActMove:
		return &"move"
	if act is teVisualActGetHurt:
		return &"get_hurt"
	if act is teVisualActRanged:
		return &"ranged"
	return &""


static func die() -> teVisualActBase:
	return teVisualActDie.new()

static func move() -> teVisualActBase:
	return teVisualActMove.new()

static func get_hurt() -> teVisualActBase:
	return teVisualActGetHurt.new()

static func melee() -> teVisualActBase:
	return teVisualActMelee.new()

static func ranged() -> teVisualActBase:
	return teVisualActRanged.new()
