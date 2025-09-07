class_name CombatHotSeatControl extends CombatPlayerControlBase


@export var players_army_map: Dictionary[String, CombatPlayer]
@export var intent_resolver: CombatPlayerIntentResolver
@export var hex_picking: HexPicking


func enable():
	set_process_unhandled_input(true)
	hex_picking.updated.connect(_on_hex_picking_updated)


func disable():
	hex_picking.updated.disconnect(_on_hex_picking_updated)
	set_process_unhandled_input(false)


var _controlled_player: CombatPlayer
var _potential_command: CombatCommandBase


func _ready() -> void:
	set_process_unhandled_input(false)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("turn_accept") and _potential_command != null:
		command_requested.emit(_potential_command)


func _on_combat_turn_started(turn_handle: CombatHandle):
	var army_id := turn_handle.id()
	if not players_army_map.has(army_id):
		_controlled_player = null
		return
	_controlled_player = players_army_map[army_id]
	enable()


func _on_combat_turn_finished():
	if _controlled_player != null:
		disable()


func _on_hex_picking_updated(previous_hex: Vector2i, hex: Vector2i):
	_potential_command = intent_resolver.get_potential_command(_controlled_player, previous_hex, hex)
	potential_command_changed.emit(_potential_command)
