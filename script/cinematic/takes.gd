class_name CinematicTakes


func _init() -> void:
	Utils.assert_static_lib()


static func signaled(cut_signal: Signal) -> CinematicTake:
	return CinematicTakeSignaled.new(cut_signal)


static func async(callable: Callable) -> CinematicTake:
	return CinematicTakeAsync.new(callable)


static func instant() -> CinematicTake:
	var take := CinematicTake.new()
	take.is_cut = true
	return take


static func fail(msg: String = "") -> CinematicTake:
	print(msg)
	var take := instant()
	take.is_aborted = true
	return take


static func timer(node: Node, time_sec: float) -> CinematicTake:
	return signaled(node.get_tree().create_timer(time_sec, true, false, true).timeout)


static func is_failed(take: CinematicTake) -> bool:
	return take.is_aborted
