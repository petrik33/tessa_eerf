@tool
extends EditorPlugin

var dock: VBoxContainer

var texture_picker: EditorResourcePicker
var output_path: LineEdit

var frame_w: SpinBox
var frame_h: SpinBox
var frames_per_anim: SpinBox
var fps: SpinBox
var start_row: SpinBox

var states_edit: LineEdit
var directions_edit: LineEdit
var loop_check: CheckBox

func _enter_tree():
	dock = VBoxContainer.new()
	dock.name = "SpriteFrames Gen"

	texture_picker = EditorResourcePicker.new()
	texture_picker.base_type = "Texture2D"

	output_path = LineEdit.new()
	output_path.placeholder_text = "res://art/generated.tres"

	frame_w = _spin(1, 512, 64)
	frame_h = _spin(1, 512, 64)
	frames_per_anim = _spin(1, 64, 8)
	fps = _spin(1, 60, 10)
	start_row = _spin(0, 128, 0)

	states_edit = LineEdit.new()
	states_edit.text = "walk,idle"

	directions_edit = LineEdit.new()
	directions_edit.text = "s,w,e,n"

	loop_check = CheckBox.new()
	loop_check.text = "Loop animations"
	loop_check.button_pressed = true

	var generate_btn = Button.new()
	generate_btn.text = "Generate SpriteFrames"
	generate_btn.pressed.connect(_generate)

	dock.add_child(_label("Spritesheet"))
	dock.add_child(texture_picker)

	dock.add_child(_label("Output .frames path"))
	dock.add_child(output_path)

	dock.add_child(_label("Frame Width"))
	dock.add_child(frame_w)

	dock.add_child(_label("Frame Height"))
	dock.add_child(frame_h)

	dock.add_child(_label("Frames per animation"))
	dock.add_child(frames_per_anim)

	dock.add_child(_label("FPS"))
	dock.add_child(fps)

	dock.add_child(_label("Start Row"))
	dock.add_child(start_row)

	dock.add_child(_label("States (comma-separated)"))
	dock.add_child(states_edit)

	dock.add_child(_label("Directions (comma-separated)"))
	dock.add_child(directions_edit)

	dock.add_child(loop_check)
	dock.add_child(generate_btn)

	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()

func _generate():
	var sheet := texture_picker.edited_resource as Texture2D
	if sheet == null:
		push_error("No spritesheet selected.")
		return

	var out_path := output_path.text.strip_edges()
	if out_path.is_empty():
		push_error("Output path is empty.")
		return

	var states := states_edit.text.split(",", false)
	var dirs := directions_edit.text.split(",", false)

	var sprite_frames := load(out_path)
	
	if sprite_frames == null:
		sprite_frames = SpriteFrames.new()
		sprite_frames.remove_animation("default")
	
	var row := start_row.value

	for state in states:
		for dir in dirs:
			var anim := state + "_" + dir
			sprite_frames.add_animation(anim)
			sprite_frames.set_animation_loop(anim, loop_check.button_pressed)
			sprite_frames.set_animation_speed(anim, fps.value)

			for i in frames_per_anim.value:
				var atlas := AtlasTexture.new()
				atlas.atlas = sheet
				atlas.region = Rect2(
					i * frame_w.value,
					row * frame_h.value,
					frame_w.value,
					frame_h.value
				)
				sprite_frames.add_frame(anim, atlas)

			row += 1

	var err := ResourceSaver.save(sprite_frames, out_path)
	if err != OK:
		push_error("Failed to save SpriteFrames.")
	else:
		print("SpriteFrames generated:", out_path)

func _spin(min, max, value):
	var s := SpinBox.new()
	s.min_value = min
	s.max_value = max
	s.value = value
	s.step = 1
	return s

func _label(text: String) -> Label:
	var l := Label.new()
	l.text = text
	return l
