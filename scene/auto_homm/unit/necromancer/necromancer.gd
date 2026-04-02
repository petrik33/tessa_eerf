@tool
extends teUnitVisualsMeleeBase


@export var cast_animation_name := &"cast"
@export var cast_frame := -1


func cast(act: teVisualActCast):
	if not animated_sprite.sprite_frames.has_animation(cast_animation_name):
		return
	
	animated_sprite.play(cast_animation_name)
	
	if cast_frame == 0:
		await animated_sprite.animation_finished
		return
	
	_windup_start()
	
	if cast_frame == -1:
		await animated_sprite.animation_finished
		_windup_finish()
		return
	
	while true:
		await animated_sprite.frame_changed
		if animated_sprite.frame >= cast_frame:
			_windup_finish()
			break
	await animated_sprite.animation_finished
