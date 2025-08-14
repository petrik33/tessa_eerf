@tool
class_name FaceWalkDirection extends Node

@export var sprite: AnimatedSprite2D:
	set(value):
		sprite = value
		update_configuration_warnings()
		
@export var inverse := false

func enable():
	set_process(true)

func disable():
	set_process(false)

var _last_pos: Vector2

func _ready() -> void:
	_last_pos = Vector2.ZERO if sprite == null else sprite.position
	disable()

func _process(delta: float) -> void:
	var delta_pos = sprite.position - _last_pos
	if not inverse:
		sprite.flip_h = cos(delta_pos.angle()) < 0
	else:
		sprite.flip_h = cos(delta_pos.angle()) > 0
	_last_pos = sprite.position

func _get_configuration_warnings() -> PackedStringArray:
	if sprite == null:
		return ["Sprite not assigned"]
	return []
