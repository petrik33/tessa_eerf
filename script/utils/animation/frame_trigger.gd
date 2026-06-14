@tool
class_name AnimationFrameTrigger extends RefCounted

signal triggered()


var sprite: AnimatedSprite2D
var is_triggered := true
var is_stopped := false


func _init(_sprite: AnimatedSprite2D):
	sprite = _sprite


func stop():
	is_stopped = true
	is_triggered = true


func start(frame: int = -1):
	assert(not waiting_for_trigger())
	_reset()
	if frame == -1:
		frame = sprite.sprite_frames.get_frame_count(sprite.animation) - 1
	if sprite.frame >= frame:
		_trigger()
		return
	await _wait_for_frame(frame)
	if is_stopped:
		return
	_trigger()


func waiting_for_trigger() -> bool:
	return not is_triggered


func _wait_for_frame(frame: int):
	while true:
		await sprite.frame_changed
		if sprite.frame >= frame or is_stopped:
			return


func _trigger():
	is_triggered = true
	triggered.emit()


func _reset():
	is_triggered = false
	is_stopped = false
