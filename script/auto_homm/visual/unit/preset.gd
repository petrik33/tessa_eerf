class_name teVisualUnitPreset extends Resource


@export var actor: PackedScene
@export var attack: teVisualUnit.Attack = teVisualUnit.Attack.MELEE
@export var skill: teVisualUnit.Skill = teVisualUnit.Skill.NONE
@export var skill_socket: StringName = teVisualUnitSockets.TARGET
@export var projectiles: Dictionary[StringName, PackedScene] = {}
@export var vfx: Dictionary[StringName, PackedScene] = {}
