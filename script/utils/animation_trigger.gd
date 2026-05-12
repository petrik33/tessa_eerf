class_name AnimationTrigger extends RefCounted

signal triggered()


var sprite: AnimatedSprite2D
var is_triggered := true


func _init(_sprite: AnimatedSprite2D):
	sprite = _sprite


func next(frame: int):
	assert(not waiting_for_trigger())
	is_triggered = false
	if sprite.frame >= frame:
		_trigger()
		return
	await _wait_for_frame(frame)
	_trigger()


func waiting_for_trigger() -> bool:
	return not is_triggered


func on_finished():
	var last_frame := sprite.sprite_frames.get_frame_count(sprite.animation) - 1
	await next(last_frame)


func _wait_for_frame(frame: int):
	while true:
		await sprite.frame_changed
		if sprite.frame >= frame:
			return


func _trigger():
	is_triggered = true
	triggered.emit()
