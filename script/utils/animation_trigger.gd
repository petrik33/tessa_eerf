class_name AnimationTrigger extends RefCounted

signal triggered()
signal finished()


var sprite: AnimatedSprite2D

var is_running := false
var is_triggered := false


func _init(_sprite: AnimatedSprite2D):
	sprite = _sprite


func run(animation: StringName, trigger_frame: int, speed_scale := 1.0) -> void:
	if is_running:
		return
	
	if not sprite.sprite_frames.has_animation(animation):
		return
	
	is_running = true
	
	sprite.play(animation, speed_scale)
	
	if trigger_frame == 0:
		_trigger()
		await sprite.animation_finished
		_finish()
		return
	
	if trigger_frame == -1:
		await sprite.animation_finished
		_trigger()
		_finish()
		return
	
	while true:
		await sprite.frame_changed
		if sprite.frame >= trigger_frame:
			_trigger()
			break
	
	await sprite.animation_finished
	_finish()


func _trigger():
	is_triggered = true
	triggered.emit()


func _finish():
	is_running = false
	is_triggered = false
	finished.emit()
