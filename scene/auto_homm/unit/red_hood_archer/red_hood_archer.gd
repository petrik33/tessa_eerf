extends teUnitVisualsMeleeBase


@export var ranged_animation_name := &"ranged"
@export var ranged_shot_frame := -1


func ranged(act: teVisualActRanged):
	if not animated_sprite.sprite_frames.has_animation(ranged_animation_name):
		return
	
	animated_sprite.play(ranged_animation_name)
	
	if ranged_shot_frame == 0:
		await animated_sprite.animation_finished
		return
	
	_windup_start()
	
	if ranged_shot_frame == -1:
		await animated_sprite.animation_finished
		_windup_finish()
		return
	
	while true:
		await animated_sprite.frame_changed
		if animated_sprite.frame >= ranged_shot_frame:
			_windup_finish()
			break
	await animated_sprite.animation_finished
