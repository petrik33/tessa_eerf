@abstract
class_name CinematicWriterBase extends Node


@abstract
func intro(initial_state: teCombatState) -> CinematicSequence

@abstract
func sequence(
	state: teCombatState,
	action: teCombatActionBase,
	context: Context,
	events_buffer: teCombatEventsBuffer
) -> teVisualActionBase
