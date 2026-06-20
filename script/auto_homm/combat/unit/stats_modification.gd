class_name teUnitStatsModification extends Resource


@export var stats: teUnitStats
@export var modifier: teUnitStatsModifierBase


func apply(base: teUnitStats) -> teUnitStats:
	var modified := teUnitStats.new()
	for property in teUnitStats.STAT_FIELDS:
		var base_stat = base.get(property)
		var modified_stat = stats.get(property)
		modified.set(property, modifier.modify(base_stat, modified_stat))
	return modified
