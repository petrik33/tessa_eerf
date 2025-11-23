class_name CombatVisualProjectile extends Node2D


signal target_reached()


@export var speed := 10.0

var target: Vector2


func fire_at(pos: Vector2):
	target = pos
	rotation = (target - position).angle()
	set_physics_process(true)


func reach_target() -> void:
	position = target
	target_reached.emit()
	set_physics_process(false)


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var to_target := target - position
	var dist := to_target.length()
	var physics_speed := delta * speed

	if dist <= physics_speed:
		reach_target()
		return

	position += to_target.normalized() * physics_speed
