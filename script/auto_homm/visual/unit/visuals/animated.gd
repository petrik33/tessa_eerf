class_name teUnitVisualsAnimated extends teUnitVisualsBase


@export var sprite: AnimatedSprite2D
@export var windup_frames: Dictionary[StringName, int]


@onready var animation_trigger := AnimationTrigger.new(sprite)

var facing_right: bool


const IDLE_ANIMATION := &"idle"
const MOVE_ANIMATION := &"walk"


func face(angle: float):
	facing_right = cos(angle) >= 0
	_update_facing()


func go_idle():
	sprite.play(IDLE_ANIMATION)
	_update_facing()


func start_moving():
	if not sprite.sprite_frames.has_animation(MOVE_ANIMATION):
		return
	sprite.play(MOVE_ANIMATION)


func knows_act(act_name: StringName) -> bool:
	return sprite.sprite_frames.has_animation(act_name)


func play_act(act_name: StringName, speed_scale: float):
	if windup_frames.has(act_name):
		await animation_trigger.run(act_name, windup_frames[act_name], speed_scale)
	else:
		sprite.play(act_name, speed_scale)
		await sprite.animation_finished


func act_duration(act_name: StringName) -> float:
	if not knows_act(act_name):
		return 0.0
	return Utils.animation_duration_sprite2d(sprite, act_name)


func is_winding_up(act_name: StringName) -> bool:
	return animation_trigger.is_running


func windup_finished(act_name: StringName) -> bool:
	return animation_trigger.is_triggered


func windup_signal(act_name: StringName) -> Signal:
	return animation_trigger.triggered


func _update_facing():
	sprite.flip_h = not facing_right
