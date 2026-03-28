@abstract
class_name teVisualWriterBase extends Resource


@abstract
func intro(initial_state: teCombatState) -> teVisualSequence

@abstract
func sequence(state: teCombatState, event_log: teCombatEventLog) -> teVisualSequence

@abstract
func write(state: teCombatState, event: teCombatEventBase) -> teVisualActionBase
