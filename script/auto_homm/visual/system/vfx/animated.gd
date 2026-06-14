@tool
class_name teVisualVfxAnimated extends teVisualVfxInstanceBase


@export var sprite: AnimatedSprite2D
@export var trigger_frame: int
@export var animation := &"default"


@onready var animation_trigger := AnimationFrameTrigger.new(sprite)


func play(_params: Dictionary, speed_scale: float):
	sprite.play(animation, speed_scale)
	animation_trigger.start(trigger_frame)


func stop():
	sprite.stop()


func duration():
	return Utils.animation_duration_sprite2d(sprite, animation)


func impact_made() -> bool:
	return animation_trigger.is_triggered


func impact_signal() -> Signal:
	return animation_trigger.triggered


func finished_signal() -> Signal:
	return sprite.animation_finished
