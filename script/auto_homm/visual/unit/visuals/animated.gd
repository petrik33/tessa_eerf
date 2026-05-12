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


func play_act(act_name: StringName, speed_scale: float, go_idle_then: bool):
	if sprite.is_playing() and sprite.animation == act_name:
		sprite.stop()
	sprite.play(act_name, speed_scale)
	await sprite.animation_finished
	if go_idle_then:
		go_idle()


func act_duration(act_name: StringName) -> float:
	if not knows_act(act_name):
		return 0.0
	return Utils.animation_duration_sprite2d(sprite, act_name)


func windup(act_name: StringName):
	if windup_frames.has(act_name):
		animation_trigger.next(windup_frames[act_name])
	else:
		animation_trigger.on_finished()


func is_acting() -> bool:
	return sprite.is_playing() and sprite.animation != IDLE_ANIMATION


func is_winding_up() -> bool:
	return animation_trigger.waiting_for_trigger()


func windup_finished() -> bool:
	return animation_trigger.is_triggered


func windup_signal() -> Signal:
	return animation_trigger.triggered


func _update_facing():
	sprite.flip_h = not facing_right
