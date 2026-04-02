class_name teVisualVfxSystem extends Node

@export var library: Dictionary[StringName, PackedScene]


var created: int = 0
var active_instances: Dictionary[int, teVisualVfxInstanceBase]
var pending_queue_free: Dictionary[int, Callable]


func _exit_tree() -> void:
	for id in active_instances:
		var instance := active_instances[id]
		var callable := pending_queue_free[id]
		instance.finished.disconnect(callable)


func play(
	vfx_id: StringName,
	position: Vector2,
	parent: Node,
	params := {}
):
	var scene: PackedScene = library.get(vfx_id)
	if scene == null:
		return null
	
	var instance: teVisualVfxInstanceBase = scene.instantiate()
	
	parent.add_child(instance)
	var instance_id := created
	active_instances[instance_id] = instance
	pending_queue_free[instance_id] = func (): _on_instance_finished(instance_id)
	
	instance.position = position
	instance.finished.connect(pending_queue_free[instance_id])
	instance.play(params)
	
	created += 1
	
	if instance.instant_impact():
		return

	return instance.impact


func _on_instance_finished(id: int):
	var instance := active_instances[id]
	active_instances.erase(id)
	pending_queue_free.erase(id)
	instance.queue_free()
