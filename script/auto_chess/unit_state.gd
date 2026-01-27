@tool
class_name acUnitState extends Resource


@export var uid: int
@export var definition: acUnit

@export var team: int
@export var hp: int
@export var mana: int

@export var hex: Vector2i
@export var facing: int

@export var alive := true
@export var stunned_until := 0.0
@export var last_attack_time := 0.0

@export var move_speed := 1.5 # Hex/s
@export var moving := false
@export var movement_target_hex: Vector2i
@export var movement_progress := 0.0


func is_moving() -> bool:
	return moving

func is_stunned() -> bool:
	return false

func is_casting() -> bool:
	return false

#var status_effects: Array[StatusEffectState]
