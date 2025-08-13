class_name SamuraiCombatVisuals extends UnitCombatVisualsBase

@export var move_speed := 80.0

func go_to_idle_animation_state():
	%AnimatedSprite2D.play("idle")
	
func face_direction(direction: float):
	if cos(direction) > 0:
		%AnimatedSprite2D.flip_h = false
	else:
		%AnimatedSprite2D.flip_h = true

func play_move(path: Array[Vector2]):
	if path.is_empty():
		return
	%AnimatedSprite2D.play("walk")
	_move_along_path(path)

func _move_along_path(path: Array[Vector2]):
	var tween = create_tween()
	var pos = global_position
	for target in path:
		var dist = pos.distance_to(target)
		var duration = dist / move_speed
		tween.tween_property(self, "global_position", target, duration)
		pos = target
	tween.finished.connect(_handle_move_finished)

func _handle_move_finished():
	go_to_idle_animation_state()
