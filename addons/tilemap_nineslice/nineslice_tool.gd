@tool
extends Button

var editor_interface
var viewport_2d
var active := false

var dragging := false
var start_cell : Vector2i
var end_cell   : Vector2i

func _ready():
	text = "9-Slice Draw"
	toggle_mode = true
	viewport_2d = EditorInterface.get_editor_viewport_2d()
	toggled.connect(_on_toggled)

func _on_toggled(enabled: bool):
	active = enabled
	if enabled:
		viewport_2d.gui_input.connect(_on_gui_input)
	else:
		if viewport_2d.gui_input.is_connected(_on_gui_input):
			viewport_2d.gui_input.disconnect(_on_gui_input)

func _on_gui_input(event: InputEvent):
	if not active:
		return

	var tilemap := _get_active_tilemap()
	if tilemap == null:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_cell = tilemap.local_to_map(
					tilemap.to_local(event.position)
				)
				end_cell = start_cell
				dragging = true
			else:
				if dragging:
					dragging = false
					_apply_nineslice(tilemap, start_cell, end_cell)

	elif event is InputEventMouseMotion and dragging:
		end_cell = tilemap.local_to_map(
			tilemap.to_local(event.position)
		)

func _get_active_tilemap() -> TileMapLayer:
	var selection = editor_interface.get_selection().get_selected_nodes()
	if selection.size() != 1:
		return null

	if selection[0] is TileMapLayer:
		return selection[0]

	return null

func _apply_nineslice(tilemap: TileMapLayer, a: Vector2i, b: Vector2i):
	var tileset := tilemap.tile_set
	if tileset == null:
		return

	var selected := tilemap.get_cell_source_id(a)
	if selected == -1:
		return

	var atlas_coords := tilemap.get_cell_atlas_coords(a)
	var tile_data = tileset.get_source(selected).get_tile_data(atlas_coords)
	if tile_data == null:
		return

	if not tile_data.has_custom_data("nine_slice"):
		return

	var slice = tile_data.get_custom_data("nine_slice")

	var min_x = min(a.x, b.x)
	var max_x = max(a.x, b.x)
	var min_y = min(a.y, b.y)
	var max_y = max(a.y, b.y)

	var width  = max_x - min_x + 1
	var height = max_y - min_y + 1

	tilemap.undo_redo.create_action("9-Slice Draw")

	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			var lx = x - min_x
			var ly = y - min_y

			var key := _resolve_slice_key(lx, ly, width, height)
			if not slice.has(key):
				continue

			var coords : Vector2i = slice[key]

			tilemap.undo_redo.add_do_method(
				tilemap,
				"set_cell",
				Vector2i(x, y),
				selected,
				coords
			)

			tilemap.undo_redo.add_undo_method(
				tilemap,
				"erase_cell",
				Vector2i(x, y)
			)

	tilemap.undo_redo.commit_action()

func _resolve_slice_key(lx: int, ly: int, w: int, h: int) -> String:
	if w == 1 and h == 1:
		return "center"

	if lx == 0 and ly == 0:
		return "top_left"
	if lx == w - 1 and ly == 0:
		return "top_right"
	if lx == 0 and ly == h - 1:
		return "bottom_left"
	if lx == w - 1 and ly == h - 1:
		return "bottom_right"

	if ly == 0:
		return "top"
	if ly == h - 1:
		return "bottom"
	if lx == 0:
		return "left"
	if lx == w - 1:
		return "right"

	return "center"
