class_name teVisualVfxSystem extends Node

@export var library: Dictionary[StringName, PackedScene]


var playing: Array[teVisualVfxInstanceBase]
var durations: Dictionary[StringName, float]


func _enter_tree() -> void:
	for uid in library:
		var vfx_scene := library[uid]
		var vfx := vfx_scene.instantiate() as teVisualVfxInstanceBase
		durations[uid] = vfx.duration()
		vfx.queue_free()


func _exit_tree() -> void:
	for instance in playing:
		instance.queue_free()


func play(
	vfx_uid: StringName,
	position: Vector2,
	parent: Node,
	speed_scale := 1.0,
	params: Dictionary = {}
):
	var scene: PackedScene = library.get(vfx_uid)
	if scene == null:
		return
	var instance = scene.instantiate() as teVisualVfxInstanceBase
	if instance == null:
		return
	instance.position = position
	parent.add_child(instance)
	instance.finished_signal().connect(func():
		parent.remove_child(instance)
		instance.queue_free()
	)
	instance.play(params, speed_scale)
	if instance.impact_made():
		return
	await instance.impact_signal()


func duration(vfx_uid: StringName) -> float:
	return durations[vfx_uid]
