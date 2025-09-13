@tool
class_name CombatVisualUnitWalkAlongPath extends Node

signal finished()

@export_tool_button("Preview", "Callable") var preview_animation = _preview
@export_tool_button("Stop Preview", "Stop") var stop_preview = _stop_preview

@export_enum("normal", "fast", "slow", "very fast", "very slow")
var walk_animation: String = "normal"

@export var moved_node: Node2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var path_follow: PathFollow2D = %PathFollow2D
@onready var path_2d: Path2D = %Path2D

func walk(action: CombatVisualUnitActionWalk) -> Signal:
	along_path(action.path)
	return finished

func along_path(path: Array[Vector2]):
	if path.is_empty():
		return
	var curve := Curve2D.new()
	for point in path:
		curve.add_point(point)
	along_curve(curve)

func along_curve(curve: Curve2D):
	if is_processing():
		stop()
	path_2d.curve = curve
	var path_len := curve.get_baked_length()
	var reference_len := UnitVisualsGlobal.reference_walk_path.get_baked_length()
	animation_player.animation_finished.connect(_handle_animation_finished)
	animation_player.play(
		animation_name_format % walk_animation, -1.0,
		reference_len / path_len
	)
	set_process(true)

func stop():
	if not is_processing():
		return
	set_process(false)
	animation_player.stop()
	animation_player.animation_finished.disconnect(_handle_animation_finished)

const animation_name_format := "combat_unit_walk_presets/%s"

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	moved_node.position = path_follow.position

func _get_configuration_warnings() -> PackedStringArray:
	if moved_node == null:
		return ["Moved node not assigned"]
	return []

func _handle_animation_finished(_anim_name: String):
	stop()
	finished.emit()

func _preview():
	along_curve(UnitVisualsGlobal.reference_walk_path)

func _stop_preview():
	stop()
	_process(0.0)
	notify_property_list_changed()
