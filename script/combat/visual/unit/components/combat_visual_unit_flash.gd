@tool
class_name CombatVisualUnitHitFlash extends Node


@export_tool_button("Preview", "Callable") var preview_flash = _preview


@export var animated_sprite: AnimatedSprite2D
@export_range(0, 10.0, 0.1, "suffix:s") var duration := 0.5
@export var count := 1
@export var shader_material: ShaderMaterial


var original_material: Material


func flash():
	if shader_material == null or animated_sprite == null:
		return

	original_material = animated_sprite.material
	animated_sprite.material = shader_material

	var tween = create_tween()
	tween.set_loops(count)

	tween.tween_method(
		func(value): shader_material.set_shader_parameter("flash_factor", value),
		0.0, 1.0, duration * 0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(
		func(value): shader_material.set_shader_parameter("flash_factor", value),
		1.0, 0.0, duration * 0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	
	if animated_sprite and animated_sprite.material == shader_material:
		animated_sprite.material = original_material


func _preview():
	flash()
