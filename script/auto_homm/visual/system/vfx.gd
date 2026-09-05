class_name teVisualVfxSystem extends Node


@export var library: Dictionary[StringName, PackedScene]
@export var parent_node: Node2D


var playing: Array[teVisualVfxInstanceBase]
var durations: Dictionary[StringName, float]


func _enter_tree() -> void:
	for uid in library:
		durations[uid] = _calc_duration(library[uid])


func _exit_tree() -> void:
	for instance in playing:
		instance.queue_free()


func add(uid: StringName, vfx_visuals: PackedScene):
	library.set(uid, vfx_visuals)
	durations[uid] = _calc_duration(vfx_visuals)


func play(
	vfx_uid: StringName,
	position: Vector2,
	speed_scale := 1.0,
	params: Dictionary = {}
):
	var scene: PackedScene = library.get(vfx_uid)
	if scene == null:
		return
	var instance = scene.instantiate() as teVisualVfxInstanceBase
	if instance == null:
		return
	parent_node.add_child(instance)
	instance.global_position = position
	instance.finished_signal().connect(func():
		parent_node.remove_child(instance)
		instance.queue_free()
	)
	instance.play(params, speed_scale)
	if instance.impact_made():
		return
	await instance.impact_signal()


func duration(vfx_uid: StringName) -> float:
	return durations[vfx_uid]


func _calc_duration(vfx_visuals: PackedScene):
	var vfx := vfx_visuals.instantiate() as teVisualVfxInstanceBase
	var duration := vfx.duration()
	vfx.queue_free()
	return duration
