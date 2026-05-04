class_name teVisualTakeAsync extends teVisualTake


func _init(callable: Callable):
	_async_call(callable)


func _async_call(callable: Callable):
	await callable.call()
	if not is_aborted:
		_cut()
