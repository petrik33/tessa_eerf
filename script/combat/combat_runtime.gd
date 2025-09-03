class_name CombatRuntime

func _init(definition: CombatDefinition, state: CombatState):
	_state = state
	_nav_context = HexNavigationContext.new(definition.grid)
	_pathfinding = HexPathfinding.new(_nav_context)

func state() -> CombatState:
	return _state

func navigation() -> HexNavigationContext:
	return _nav_context

func pathfinding() -> HexPathfinding:
	return _pathfinding

var _state: CombatState
var _nav_context: HexNavigationContext
var _pathfinding: HexPathfinding
var _occupied_hex: Array[int]
