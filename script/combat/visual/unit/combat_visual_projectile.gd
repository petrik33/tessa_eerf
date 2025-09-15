class_name CombatVisualProjectile extends Node2D


signal target_reached()


@export var target: Vector2
@export var speed := 10.0


var reached := false


func is_target_reached() -> bool:
	return reached


func reach_target() -> void:
	position = target
	reached = true
	target_reached.emit()
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	var to_target := target - position
	var dist := to_target.length()
	var physics_speed := delta * speed
	
	if dist <= physics_speed:
		reach_target()
	
	position += to_target.normalized() * physics_speed
