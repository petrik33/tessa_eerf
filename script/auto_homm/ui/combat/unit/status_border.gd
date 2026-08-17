@tool
class_name teCombatUnitStatusBorder extends Control


@export var statuses: Dictionary[String, teCombatUnitEffectStatus] = {}
@export var segment_offset: float = 3.0


var effect_instances: Array[int] = []
var instance_names: Dictionary[int, StringName] = {}
var flash_tween: Tween


func _ready() -> void:
	clear()


func clear():
	for effect_name in statuses:
		statuses[effect_name].segments.clear()
		statuses[effect_name].queue_redraw()
	effect_instances.clear()
	instance_names.clear()


func shows_effect(effect_name: StringName) -> bool:
	return statuses.has(effect_name)


func flash(effect_name: StringName):
	var status := statuses[effect_name]
	status.flash()


func add_effect_instance(instance: teCombatEffectInstance, id: int):
	var effect_name := teCombatEffects.get_common_effect_name(instance.effect)
	var status := statuses[effect_name]
	var segment := teCombatUnitEffectSegment.new()
	segment.ticks = instance.charges_left
	effect_instances.append(id)
	instance_names[id] = effect_name
	status.segments[id] = segment
	_recalculate_segment_offsets()
	_redraw_statuses()


func set_effect_instance(instance: teCombatEffectInstance, id: int):
	var effect_name := teCombatEffects.get_common_effect_name(instance.effect)
	var status := statuses[effect_name]
	status.segments[id].ticks = instance.charges_left
	_recalculate_segment_offsets()
	_redraw_statuses()


func remove_effect_instancec(instance: teCombatEffectInstance, id: int):
	var effect_name := teCombatEffects.get_common_effect_name(instance.effect)
	var status := statuses[effect_name]
	status.segments.erase(id)
	effect_instances.erase(id)
	instance_names.erase(id)
	_recalculate_segment_offsets()
	_redraw_statuses()


func _recalculate_segment_offsets():
	var total_offset := 0.0
	for id in effect_instances:
		var effect_name := instance_names[id]
		var status := statuses[effect_name]
		status.segments[id].offset = total_offset
		total_offset += status.get_segment_width(id) + segment_offset


func _redraw_statuses():
	for effect_name in statuses:
		statuses[effect_name].queue_redraw()
