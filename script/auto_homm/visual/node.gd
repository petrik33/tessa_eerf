class_name teVisual extends Node


@export var preset: teVisualPreset
@export var projectile: teVisualProjectileSystem
@export var vfx: teVisualVfxSystem


const RANGED_PROJECTILE_POSTFIX = "_ranged"
const CAST_VFX_POSTFIX = "_cast"
const SKILL_VFX_POSTFIX = "_skill"


func _ready() -> void:
	for unit_uid in preset.units.presets:
		var unit_preset = preset.units.presets[unit_uid]
		var unit_projectiles = unit_preset.projectiles
		for projectile_name in unit_projectiles:
			projectile.add(unit_uid + "_" + projectile_name, unit_projectiles[projectile_name])
		var unit_vfx = unit_preset.vfx
		for vfx_name in unit_vfx:
			vfx.add(unit_uid + "_" + vfx_name, unit_vfx[vfx_name])


func get_unit_preset(uid: StringName) -> teVisualUnitPreset:
	return preset.units.presets[uid]


static func unit_projectile_name(unit_uid: StringName) -> StringName:
	return unit_uid + RANGED_PROJECTILE_POSTFIX


static func unit_cast_vfx_uid(unit_uid: StringName) -> StringName:
	return unit_uid + CAST_VFX_POSTFIX

static func unit_skill_vfx_uid(unit_uid: StringName) -> StringName:
	return unit_uid + SKILL_VFX_POSTFIX
