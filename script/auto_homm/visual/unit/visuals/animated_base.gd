class_name teUnitVisualsAnimatedBase extends teUnitVisualsBase


@export var animated_sprite: AnimatedSprite2D

@export var idle_animation_name: StringName = &"idle"
@export var hurt_animation_name: StringName = &"hurt"
@export var death_animation_name: StringName = &"death"


func go_idle():
	animated_sprite.play(idle_animation_name)


func get_hurt(act: teVisualActGetHurt):
	if not animated_sprite.sprite_frames.has_animation(hurt_animation_name):
		go_idle()
		return
	animated_sprite.play(hurt_animation_name)
	return animated_sprite.animation_finished


func die(act: teVisualActDie):
	if not animated_sprite.sprite_frames.has_animation(death_animation_name):
		return
	animated_sprite.play(death_animation_name)
	return animated_sprite.animation_finished
