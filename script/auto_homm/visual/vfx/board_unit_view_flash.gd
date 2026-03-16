class_name teBoardUnitViewFlash extends Node


@export var flash_material: ShaderMaterial
@export var target_strength := 1.0

@export var trans_type := Tween.TRANS_QUAD
@export var ease_type := Tween.EASE_OUT

@export var up_weight := 1.0
@export var hold_weight := 0.5
@export var down_weight := 1.5


var target_node: Node2D
var tween: Tween


func _get_configuration_warnings() -> PackedStringArray:
	if flash_material == null:
		return ["Flash material not set"]
	return []


func reset_target():
	target_node = null


func set_target(node: Node2D):
	target_node = node


func flash(time: float = 1.0, color := Color.WHITE):
	target_node.material = flash_material
	
	flash_material.set_shader_parameter("flash_color", color)
	flash_material.set_shader_parameter("strength", 0.0)
	
	if tween and tween.is_running():
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(trans_type)
	tween.set_ease(ease_type)
	
	var total_weight := up_weight + hold_weight + down_weight
	if total_weight <= 0.0:
		total_weight = 1.0
	
	var up_time := time * (up_weight / total_weight)
	var hold_time := time * (hold_weight / total_weight)
	var down_time := time * (down_weight / total_weight)
	
	tween.tween_property(
		flash_material,
		"shader_parameter/strength",
		target_strength,
		up_time
	).from(0.0)
	
	tween.tween_interval(hold_time)
	
	tween.tween_property(
		flash_material,
		"shader_parameter/strength",
		0.0,
		down_time
	)
