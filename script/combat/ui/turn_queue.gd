class_name CombatUiTurnQueue extends Control


@export var army_colors: Dictionary[String, Color]:
	set(value):
		army_colors = value
		queue_redraw()

@export var container: Container
@export var unit_entry_scene: PackedScene
@export var separator_scene: PackedScene


func update(state: CombatState):
	for entry in entries:
		entry.queue_free()
	for separator in separators:
		separator.queue_free()
	entries.clear()
	separators.clear()
	for unit_handle in state.turn_queue:
		var unit_state := state.unit(unit_handle)
		var entry := unit_entry_scene.instantiate() as CombatUiTurnQueueUnitEntry
		entry.text = unit_state.unit.name
		var army_id := unit_state.army_handle.id()
		if army_colors.has(army_id):
			entry.set_underline_color(army_colors[army_id])
		container.add_child(entry)
		entries.push_back(entry)
		var separator := separator_scene.instantiate()
		container.add_child(separator)
		separators.push_back(separator)
	


var entries: Array[CombatUiTurnQueueUnitEntry]
var separators: Array[Separator]
