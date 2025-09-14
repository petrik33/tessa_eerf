class_name UnitCombatStats extends Resource

@export var attack := 10
@export var defense := 10
@export var damage_range := Vector2i(5, 10) # min and max damage
@export var hp := 30

@export var morale := 0 # can be negative
@export var luck := 0
@export var speed := 5 # movement points
@export var initiative := 10 # determines turn order

@export var range := 1
