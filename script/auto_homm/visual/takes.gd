class_name teVisualTakes


func _init() -> void:
	Utils.assert_static_lib()


static func signaled(cut_signal: Signal) -> teVisualTake:
	return teVisualTakeSignaled.new(cut_signal)


static func async(callable: Callable) -> teVisualTake:
	return teVisualTakeAsync.new(callable)


static func instant() -> teVisualTake:
	var take := teVisualTake.new()
	take.is_cut = true	
	return take


static func fail(msg: String = "") -> teVisualTake:
	print(msg)
	return instant()


static func timer(node: Node, time_sec: float) -> teVisualTake:
	return signaled(node.get_tree().create_timer(time_sec).timeout)
