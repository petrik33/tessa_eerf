@tool
class_name CombatVisualUnit extends Node

@export var config: CombatVisualUnitConfig

const EFFECT_START_METHOD_NAME_PREFIX = "start_"
const EFFECT_STOP_METHOD_NAME_PREFIX = "stop_"

func get_resolver(id: StringName) -> CombatVisualActionResolver:
	return config.resolvers[id]

func get_performer(resolver: CombatVisualActionResolver) -> Node:
	return get_node(resolver.performer)

func get_effects(resolver: CombatVisualActionResolver) -> Array[Node]:
	var effects: Array[Node] = []
	for path in resolver.effects:
		effects.push_back(get_node(path))
	return effects

func start_effect(node: Node, id: StringName, action: CombatVisualActionBase):
	node.set_process(true)
	var start_method_name = get_effect_start_method_name(id)
	if node.has_method(start_method_name):
		node.call(start_method_name, action)

func stop_effect(node: Node, id: StringName):
	var stop_method_name = get_effect_stop_method_name(id)
	if node.has_method(stop_method_name):
		node.call(stop_method_name)
	node.set_process(false)

func get_effect_start_method_name(id: StringName) -> String:
	return EFFECT_START_METHOD_NAME_PREFIX + id

func get_effect_stop_method_name(id: StringName) -> String:
	return EFFECT_STOP_METHOD_NAME_PREFIX + id

func execute(action: CombatVisualUnitActionBase):
	var resolver := get_resolver(action.id)
	var executed = get_performer(resolver).call(action.id, action)
	var effects = get_effects(resolver)
	for node in effects:
		start_effect(node, action.id, action)
	await executed
	for node in effects:
		stop_effect(node, action.id)
