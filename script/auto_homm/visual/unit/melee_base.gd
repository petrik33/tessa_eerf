class_name teUnitVisualsMeleeBase extends teUnitVisualsAnimatedBase


@export var melee_animation_name: StringName = "melee"
@export var melee_hit_frame: int = -1


func melee(act: teVisualActMelee):
	_windup_start()
	animated_sprite.play(melee_animation_name)
	# TODO: reimplement with timers later?
	if melee_hit_frame != -1:
		await animated_sprite.animation_finished
		_windup_finish()
	else:
		while true:
			await animated_sprite.frame_changed
			if animated_sprite.frame >= melee_hit_frame:
				_windup_finish()
				break
		await animated_sprite.animation_finished
