class_name UnitCombatStats extends Resource

# Basic combat stats
@export var attack := 10
@export var defense := 10
@export var damage := Vector2i(5, 10) # min and max damage
@export var hp := 30
@export var max_hp := 30

# Special stats
@export var morale := 0 # can be negative
@export var luck := 0
@export var speed := 5 # movement points
@export var initiative := 10 # determines turn order

# Attack range type
enum RangeType {NONE, HALF, MAX}
@export var range_type := RangeType.NONE
