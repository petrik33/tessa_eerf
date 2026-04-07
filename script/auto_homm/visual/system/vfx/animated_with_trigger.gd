class_name teVisualVfxAnimatedWithTrigger extends teVisualVfxInstanceBase


@export var sprite: AnimatedSprite2D
@export var trigger_frame: int
@export var animation := &"default"


@onready var animation_trigger := AnimationTrigger.new(sprite)


func play(_params: Dictionary):
	animation_trigger.run(animation, trigger_frame)


func impact_made() -> bool:
	return animation_trigger.is_triggered


func impact_signal() -> Signal:
	return animation_trigger.triggered


func finished_signal() -> Signal:
	return animation_trigger.finished
