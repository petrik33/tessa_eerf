class_name teVisualVfxAnimated extends teVisualVfxInstanceBase


@export var animated_sprite: AnimatedSprite2D
@export var animation_name: StringName = "default"
@export var impact_frame := -1


func play(_params: Dictionary):
	if not animated_sprite.sprite_frames.has_animation(animation_name):
		finished.emit()
		return
	
	animated_sprite.play(animation_name)
	
	if impact_frame == -1:
		await animated_sprite.animation_finished
		impact.emit()
		finished.emit()
		return
	
	while animated_sprite.frame != impact_frame:
		await animated_sprite.frame_changed
	
	impact.emit()
	await animated_sprite.animation_finished
	finished.emit()


func instant_impact() -> bool:
	return impact_frame == 0 or not animated_sprite.sprite_frames.has_animation(animation_name)
