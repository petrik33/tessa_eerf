class_name AnimationEndTrigger extends RefCounted


signal triggered()


var sprite: AnimatedSprite2D
var is_triggered := false


func _init(_sprite: AnimatedSprite2D):
	sprite = _sprite
	_start()


func _start():
	await sprite.animation_finished
	triggered.emit()
	is_triggered = true
