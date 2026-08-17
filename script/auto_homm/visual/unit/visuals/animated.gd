class_name teUnitVisualsAnimated extends teUnitVisualsBase


@export var sprite: AnimatedSprite2D
@export var windup_frames: Dictionary[StringName, int]


@onready var windup_trigger := AnimationFrameTrigger.new(sprite)

var winddown_trigger: AnimationEndTrigger
var facing_right: bool


const IDLE_ANIMATION := &"idle"
const MOVE_ANIMATION := &"walk"


func go_idle():
	sprite.play(IDLE_ANIMATION)
	_update_facing()

func start_moving():
	if not sprite.sprite_frames.has_animation(MOVE_ANIMATION):
		return
	sprite.play(MOVE_ANIMATION)


func face(angle: float):
	facing_right = cos(angle) >= 0
	_update_facing()

func act(act_name: StringName, speed_scale: float):
	sprite.play(act_name, speed_scale)

func windup(act_name: StringName):
	windup_trigger.start(_windup_frame(act_name))

func winddown():
	if not sprite.is_playing():
		return
	assert(winddown_trigger == null, "Already winding down")
	winddown_trigger = Utils.animation_end_trigger(sprite)
	winddown_trigger.triggered.connect(_on_winddown)

func stop_acting():
	sprite.stop()
	if winddown_trigger != null:
		winddown_trigger.triggered.disconnect(_on_winddown)
		winddown_trigger = null


func act_duration(act_name: StringName) -> float:
	return Utils.animation_duration_sprite2d(sprite, act_name)

func windup_duration(act_name: StringName):
	return Utils.animation_duration_sprite2d(sprite, act_name, _windup_frame(act_name))

func winddown_duration(act_name: StringName):
	var from := _windup_frame(act_name)
	if from == -1:
		from = 0
	return Utils.animation_duration_sprite2d(sprite, act_name, -1, from)

func combo_duration(base_act: StringName, idx: int, total: int):
	var combo_from := 0
	if idx > 0:
		combo_from = _windup_frame(combo_windup_name(base_act, idx - 1))
	var combo_frame := _windup_frame(combo_windup_name(base_act, idx))
	var combo_animation := combo_act_name(base_act, total)
	return Utils.animation_duration_sprite2d(
		sprite,
		combo_animation,
		combo_frame - combo_from,
		combo_from,
	)


func knows_act(act_name: StringName) -> bool:
	return sprite.sprite_frames.has_animation(act_name)


func is_acting() -> bool:
	return sprite.is_playing() and sprite.animation != IDLE_ANIMATION

func is_winding_up() -> bool:
	return windup_trigger.waiting_for_trigger()


func windup_finished() -> bool:
	return windup_trigger.is_triggered

func windup_signal() -> Signal:
	return windup_trigger.triggered

func act_finished_signal() -> Signal:
	return sprite.animation_finished


func _update_facing():
	sprite.flip_h = not facing_right

func _windup_frame(windup_name: StringName) -> int:
	return windup_frames.get(windup_name, -1)

func _on_winddown():
	go_idle()
	winddown_trigger = null
