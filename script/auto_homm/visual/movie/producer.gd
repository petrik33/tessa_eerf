class_name teMovieProducer extends Node


@export var director: teVisualDirectorBase
@export var writer: teVisualWriterBase
@export var cutter: teVisualCutterBase


func sequence(state: teCombatState, resolved: teCombatResolvedAction) -> teVisualSequence:
	var root_visual := writer.sequence(state, resolved.action, resolved.context, resolved.emitted_events)
	if root_visual == null:
		return null
	var timeout := cutter.cut_time(resolved.action)
	return teVisualSequence.new(director, root_visual, timeout)
