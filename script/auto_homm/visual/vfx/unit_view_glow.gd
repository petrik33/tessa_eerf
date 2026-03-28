class_name teUnitViewGlow extends Node


@export var glow_up_time := 0.24
@export var glow_material: ShaderMaterial


var glow_node: Node2D
var glow_tween: Tween
var glow_target := 0.0


func _get_configuration_warnings() -> PackedStringArray:
	if glow_material == null:
		return ["Glow material not set"]
	return []


func setup(node_to_glow: Node2D):
	glow_node = node_to_glow


func update(target: float):
	if glow_node == null:
		return
	
	glow_node.material = glow_material
	
	if is_equal_approx(target, glow_target):
		return
	
	glow_target = target
		
	if glow_tween and glow_tween.is_running():
		glow_tween.kill()
		
	glow_tween = create_tween()
	glow_tween.set_trans(Tween.TRANS_QUAD)
	glow_tween.set_ease(Tween.EASE_OUT)
	glow_tween.tween_property(
		glow_material,
		"shader_parameter/glow_strength",
		glow_target,
		glow_up_time * glow_target if glow_target > 0 else glow_up_time
	).from_current()
