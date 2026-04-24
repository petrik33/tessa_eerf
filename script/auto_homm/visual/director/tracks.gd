class_name teVisualDirectorTracks


func _init() -> void:
	Utils.assert_static_lib()


static func parallel(action: teVisualActionParallel, director: teVisualDirector, speed_scale: float) -> teVisualDirectorParallelTrack:
	var track := teVisualDirectorParallelTrack.new()
	track.action = action
	track.director = director
	track.speed_scale = speed_scale
	return track


static func sequential(action: teVisualActionSubSequence, director: teVisualDirector, speed_scale: float) -> teVisualDirectorSequentialTrack:
	var track := teVisualDirectorSequentialTrack.new()
	track.action = action
	track.director = director
	track.speed_scale = speed_scale
	return track


static func signaled(_signal: Signal) -> teVisualDirectorSignaledTrack:
	var track := teVisualDirectorSignaledTrack.new()
	track._signal = _signal
	return track


static func instant() -> teVisualDirectorInstantTrack:
	return teVisualDirectorInstantTrack.new()


static func timer(node: Node, time_sec: float) -> teVisualDirectorSignaledTrack:
	return signaled(node.get_tree().create_timer(time_sec).timeout)


static func fail() -> teVisualDirectorInstantTrack:
	return teVisualDirectorInstantTrack.new()


static func coroutine(callable: Callable, ...args: Array) -> teVisualDirectorCoroutineTrack:
	var track := teVisualDirectorCoroutineTrack.new()
	track.callable = callable
	track.args = args
	return track
