class_name CombatUI extends Node

@export var observer: CombatObserver
@export var visual: CombatVisual

@export var outlines: Node2D
@export var unit_markers: CombatUiUnitMarkers

@export var cursor_arrow: Texture2D
@export var cursor_point: Texture2D
@export var cursor_attack_melee: Texture2D

var _markers: Array[CombatUiUnitsLeftMarker] = []

func _on_potential_command_changed(command: CombatCommandBase):
	if command == null:
		Input.set_custom_mouse_cursor(cursor_arrow)
	elif command is CombatCommandMoveUnit:
		Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_ARROW, Vector2(5, 0))
	elif command is CombatCommandAttackUnit:
		Input.set_custom_mouse_cursor(cursor_attack_melee, Input.CURSOR_ARROW)


func _on_turn_started(side_idx: int):
	outlines.show()


func _on_turn_finished(side_idx: int):
	outlines.hide()


func _on_visual_setup_finished():
	unit_markers.create_units_left_markers()


func _on_visual_reset_finished():
	unit_markers.destroy_units_left_markers()
