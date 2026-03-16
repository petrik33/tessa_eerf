class_name teUnitVisualsAnimatedBase extends teUnitVisuals


@export var animated_sprite: AnimatedSprite2D

@export var idle_animation_name: StringName = &"idle"
@export var hurt_animation_name: StringName = &"hurt"
@export var death_animation_name: StringName = &"death"


func go_idle():
	animated_sprite.play(idle_animation_name)


func get_hurt(act: teVisualActGetHurt):
	if hurt_animation_name == "":
		go_idle()
		return
	animated_sprite.play(hurt_animation_name)
	if not animated_sprite.is_playing():
		return
	return animated_sprite.animation_finished


func die(act: teVisualActDie):
	print("I DIED")
	animated_sprite.play(death_animation_name)
	if not animated_sprite.is_playing():
		return
	return animated_sprite.animation_finished
