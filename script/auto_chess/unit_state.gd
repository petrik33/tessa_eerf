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

#var status_effects: Array[StatusEffectState]
