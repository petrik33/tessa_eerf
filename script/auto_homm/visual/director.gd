class_name teVisualDirector extends Node


@export var board: teBoardVisual


signal started(action: teVisualActionBase)
signal played(action: teVisualActionBase)


func playing() -> bool:
	return _playing > 0


func queue_empty() -> bool:
	return _queue.is_empty()


func play(sequence: teVisualSequence):
	enqueue(sequence)
	if not playing():
		play_next()


func enqueue(sequence: teVisualSequence):
	_queue.push_back(sequence)


func play_next():
	var sequence = _queue.pop_front()
	while sequence.actions.is_empty():
		if _queue.is_empty():
			return
		sequence = _queue.pop_front()
	for action in sequence.actions:
		await play_action(action)


func play_action(action: teVisualActionBase):
	_playing += 1
	started.emit(action)
	await direct_action(action)
	played.emit(action)
	_playing -= 1
	if playing():
		return
	if not queue_empty():
		play_next()


func direct_action(action: teVisualActionBase):
	print(action.dbg_dump())
	if action is teVisualActionParallel:
		for sub_action in action.actions:
			play_action(sub_action)
	if action is teVisualActionSubSequence:
		for sub_action in action.actions:
			await play_action(sub_action)
	if action is teVisualActionUnitWindup:
		var visuals := board.get_unit_visuals(action.unit_id)
		if not visuals.winding_up:
			return
		await visuals.windup
	if action is teVisualActionUnitSequence:
		var visuals = board.get_unit_visuals(action.unit_id)
		for act in action.acts:
			var method_name := teVisualActs.name(act)
			if not visuals.has_method(method_name):
				continue
			await visuals.call(method_name, act)
		visuals.go_idle()



var _queue: Array[teVisualSequence]
var _playing: int
