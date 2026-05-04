@abstract
class_name teVisualWriterBase extends Node


@abstract
func intro(initial_state: teCombatState) -> teVisualSequence

@abstract
func sequence(
	state: teCombatState,
	action: teCombatActionBase,
	events: Array[teCombatEventBase]
) -> teVisualActionBase
