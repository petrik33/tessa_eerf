class_name teUnitViewGlow extends Node


@export var glow_up_time := 0.24


var glow_node: Node2D
var glow_tween: Tween
var glow_target := 0.0


const GLOW_MATERIAL_BASE: ShaderMaterial = preload(
	"res://resource/material/auto_chess/unit_pixel_art_glow.tres"
)

func _get_configuration_warnings() -> PackedStringArray:
	if glow_node == null:
		return ["Glow node not set"]
	if glow_node.material != null:
		return ["Material overriden for glow node will be replaced on _ready"]
	return []


func setup(node_to_glow: Node2D):
	glow_node = node_to_glow
	glow_node.material = GLOW_MATERIAL_BASE.duplicate()


func update(target: float):
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
