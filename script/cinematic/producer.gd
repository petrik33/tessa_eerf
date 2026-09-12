class_name CinematicProducer extends Node


@export var director: CinematicDirectorBase
@export var writer: CinematicWriterBase
@export var cutter: CinematicCutterBase


func sequence(state: teCombatState, resolved: teCombatResolvedAction) -> CinematicSequence:
	var root_visual := writer.sequence(state, resolved.action, resolved.context, resolved.emitted_events)
	if root_visual == null:
		return null
	var timeout := cutter.cut_time(resolved.action)
	return CinematicSequence.new(director, root_visual, timeout)
