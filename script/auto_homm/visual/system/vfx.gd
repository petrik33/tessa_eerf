class_name teVisualVfxSystem extends Node

@export var library: Dictionary[StringName, PackedScene]


var playing: Array[teVisualVfxInstanceBase]


func _exit_tree() -> void:
	for instance in playing:
		instance.queue_free()


func play(
	vfx_id: StringName,
	position: Vector2,
	parent: Node,
	params: Dictionary
):
	var scene: PackedScene = library.get(vfx_id)
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
	instance.play(params)
	if instance.impact_made():
		return
	await instance.impact_signal()
	
