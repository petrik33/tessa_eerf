@tool
class_name Utils

func _init() -> void:
	assert_static_lib()


static func to_typed(type: int, array: Array):
	return Array(array, type, "", null)


static func next_frame_timeout(node: Node) -> Signal:
	return node.get_tree().create_timer(0.0000001, true, false, true).timeout


static func next_frame(node: Node, callable: Callable, ...args: Array):
	await next_frame_timeout(node)
	callable.call(args)


static func assert_static_lib():
	assert(false, "Static lib shouldn't be constructed")
