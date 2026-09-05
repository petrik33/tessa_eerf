class_name teVisual extends Node


@export var profile: teVisualProfile
@export var projectile: teVisualProjectileSystem
@export var vfx: teVisualVfxSystem


const RANGED_PROJECTILE_POSTFIX = "_ranged"
const CAST_VFX_POSTFIX = "_cast"
const SKILL_VFX_POSTFIX = "_skill"


func _ready() -> void:
	for unit_uid in profile.units:
		var unit_profile = profile.units[unit_uid]
		var unit_projectiles = unit_profile.projectiles
		for projectile_name in unit_projectiles:
			projectile.add(unit_uid + "_" + projectile_name, unit_projectiles[projectile_name])
		var unit_vfx = unit_profile.vfx
		for vfx_name in unit_vfx:
			vfx.add(unit_uid + "_" + vfx_name, unit_vfx[vfx_name])


static func unit_projectile_name(unit_uid: StringName) -> StringName:
	return unit_uid + RANGED_PROJECTILE_POSTFIX


static func unit_cast_vfx_uid(unit_uid: StringName) -> StringName:
	return unit_uid + CAST_VFX_POSTFIX

static func unit_skill_vfx_uid(unit_uid: StringName) -> StringName:
	return unit_uid + SKILL_VFX_POSTFIX
