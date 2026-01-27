@tool
class_name acUnit extends Resource


@export var display_name: String
@export var cost: int
@export var max_hp: int
@export var attack_damage: int
@export var attack_speed: float
@export var attack_range: int = 1
@export var base_move_speed: float = 1.5 # Hex/s
@export var armor: int
@export var magic_resist: int
@export var traits: Array[StringName]
@export var ability: acAbility
