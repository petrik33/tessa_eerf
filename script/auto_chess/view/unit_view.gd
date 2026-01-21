@tool
class_name acUnitView extends Node2D


@export var glow_node: Node2D
@export var glow_up_time := 0.24

@export var dragged_glow_strength := 1.0
@export var selected_glow_strength := 0.9
@export var hovered_glow_strength := 0.6


var glow_tween: Tween
var glow_target := 0.0

var is_dragged := false
var is_selected := false
var is_hovered := false


const GLOW_MATERIAL_BASE: ShaderMaterial = preload(
	"res://resource/material/auto_chess/unit_pixel_art_glow.tres"
)


func _get_configuration_warnings() -> PackedStringArray:
	if glow_node == null:
		return ["Glow node not set"]
	if glow_node.material != null:
		return ["Material overriden for glow node will be replaced on _ready"]
	return []


func _enter_tree() -> void:
	if glow_node != null:
		glow_node.material = GLOW_MATERIAL_BASE.duplicate()


func set_hovered(hovered: bool):
	is_hovered = hovered
	update_glow()


func set_selected(selected: bool):
	is_selected = selected
	update_glow()


func sync_from_state(state: acUnitState):
	pass


func update_glow():
	if glow_node == null or glow_node.material == null:
		return
	
	var target := 0.0
	
	if is_dragged:
		target = dragged_glow_strength
	elif is_selected:
		target = selected_glow_strength
	elif is_hovered:
		target = hovered_glow_strength

	if is_equal_approx(target, glow_target):
		return
	
	glow_target = target
		
	if glow_tween and glow_tween.is_running():
		glow_tween.kill()
		
	glow_tween = create_tween()
	glow_tween.set_trans(Tween.TRANS_QUAD)
	glow_tween.set_ease(Tween.EASE_OUT)
	glow_tween.tween_property(
		glow_node.material,
		"shader_parameter/glow_strength",
		glow_target,
		glow_up_time * glow_target if glow_target > 0 else glow_up_time
	).from_current()
