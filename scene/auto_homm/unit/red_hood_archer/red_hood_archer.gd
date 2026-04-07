extends teUnitVisualsAnimated


@export var ranged_arrow_origin: Node2D


func ranged_socket() -> Vector2:
	return ranged_arrow_origin.global_position
