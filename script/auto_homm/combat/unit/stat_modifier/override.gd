class_name teUnitStatsModifierOverride extends teUnitStatsModifierBase


func modify(base_stat: Variant, modified_stat: Variant) -> Variant:
	if modified_stat >= 0:
		return modified_stat
	else:
		return base_stat
