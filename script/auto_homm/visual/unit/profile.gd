class_name teVisualUnitProfile extends Resource


@export var visuals: PackedScene
@export var attack: teVisualWriting.AttackKind = teVisualWriting.AttackKind.MELEE
@export var skill: teVisualWriting.SkillVisual = teVisualWriting.SkillVisual.NONE
@export var skill_socket: StringName = teVisualUnitSockets.TARGET
@export var projectiles: Dictionary[StringName, PackedScene] = {}
@export var vfx: Dictionary[StringName, PackedScene] = {}
