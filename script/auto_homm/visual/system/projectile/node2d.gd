@tool
class_name teVisualProjectileNode2D extends Node2D


signal reached_target()


@export var path: Path2D
@export var path_follow: PathFollow2D
@export var animation_player: AnimationPlayer


@export var trajectory: teVisualProjectileTrajectory:
	set(value):
		trajectory = value
		_apply_trajectory()


const BASE_TRAJECTORY_LENGTH := 100.0
const ANIMATION_NAME := "trajectory"


func shoot(visuals: Node2D, target: Vector2, speed_multiplier := 1.0):
	_apply_transform(target)
	path_follow.add_child(visuals)
	animation_player.speed_scale = scale.x * speed_multiplier
	animation_player.play(ANIMATION_NAME)
	await animation_player.animation_finished
	reached_target.emit()


func _apply_transform(target: Vector2):
	var target_scale = target.length() / BASE_TRAJECTORY_LENGTH
	rotation = target.angle()
	path.scale = Vector2(target_scale, target_scale)
	path_follow.scale = Vector2(1 / target_scale, 1 / target_scale)


func _apply_trajectory():
	if trajectory == null:
		return

	if path == null or path_follow == null or animation_player == null:
		return

	path.curve = trajectory.curve.duplicate()
	animation_player.remove_animation_library("")

	var lib := AnimationLibrary.new()
	lib.add_animation(ANIMATION_NAME, trajectory.animation)
	animation_player.add_animation_library("", lib)
