class_name teVisualActs


func _init() -> void:
	Utils.assert_static_lib()


const MELEE := &"melee"
const GET_HURT := &"hurt"
const RANGED := &"ranged"
const CAST := &"cast"
const DIE := &"death"
const MOVE := &"walk"


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
	if act is teVisualActCast:
		return &"cast"
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

static func cast() -> teVisualActBase:
	return teVisualActCast.new()
