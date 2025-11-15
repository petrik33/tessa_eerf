class_name CombatUiModuleBase extends Control


signal command_requested(command: CombatCommandBase)


@export var submodules: Array[CombatUiModuleBase]


func setup(initial_state: CombatState, visual: CombatVisual):
	for module in submodules:
		module.command_requested.connect(_on_submodule_command_requested)
		module.setup(initial_state, visual)


func reset():
	for module in submodules:
		module.reset()
		module.command_requested.disconnect(_on_submodule_command_requested)


func start_turn(turn_context: CombatTurnContext):
	for module in submodules:
		module.start_turn(turn_context)


func finish_turn():
	for module in submodules:
		module.finish_turn()


func update(state: CombatState):
	for module in submodules:
		module.update(state)


func _on_submodule_command_requested(command: CombatCommandBase):
	command_requested.emit(command)
