class_name CombatRuntime

func _init(config: CombatConfig, state: CombatState):
	_state = state
	_nav_context = HexNavigationContext.new(config.grid)
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
