class_name teUnitVisualsAnimated extends teUnitVisualsBase


@export var sprite: AnimatedSprite2D
@export var windup_frames: Dictionary[StringName, int]


@onready var animation_trigger := AnimationTrigger.new(sprite)


const IDLE_ANIMATION := &"idle"
const MOVE_ANIMATION := &"walk"


func go_idle():
	sprite.play(IDLE_ANIMATION)


func start_moving():
	if not sprite.sprite_frames.has_animation(MOVE_ANIMATION):
		return
	sprite.play(MOVE_ANIMATION)


func knows_act(act_name: StringName) -> bool:
	return sprite.sprite_frames.has_animation(act_name)


func play_act(act_name: StringName):
	if windup_frames.has(act_name):
		await animation_trigger.run(act_name, windup_frames[act_name])
	else:
		sprite.play(act_name)
		await sprite.animation_finished


func is_winding_up(act_name: StringName) -> bool:
	return animation_trigger.is_running


func windup_finished(act_name: StringName) -> bool:
	return animation_trigger.is_triggered


func windup_signal(act_name: StringName) -> Signal:
	return animation_trigger.triggered
