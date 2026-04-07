class_name teVisualDirectorCoroutineTrack extends teVisualDirectorTrackBase


var callable: Callable
var args: Array


func play():
	if args == null or args.is_empty():
		await callable.call()
	else:
		await callable.call(args)
	_finish()
