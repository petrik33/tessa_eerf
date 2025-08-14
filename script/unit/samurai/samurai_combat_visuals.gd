class_name SamuraiCombatVisuals extends UnitCombatVisualsBase

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var walk_along_impl: WalkAlongImpl = %WalkAlong
@onready var face_walk_direction: FaceWalkDirection = %FaceWalkDirection

func go_to_idle():
	animated_sprite.play("idle")
	
func face_direction(direction: float):
	animated_sprite.flip_h = cos(direction) < 0

func walk_along(path: Array[Vector2]):
	animated_sprite.play("walk")
	walk_along_impl.along_path(path)
	face_walk_direction.enable()

func _on_walk_along_finished() -> void:
	face_walk_direction.disable()
	walk_along_finished.emit()
