class_name teVisualUnitShadow extends Node2D


enum Size {
	SMALL,
	MEDIUM,
	BIG
}


@export var sprite: Sprite2D
@export var small_texture: Texture2D
@export var medium_texture: Texture2D
@export var big_texture: Texture2D


func set_size(shadow_size: Size):
	match shadow_size:
		Size.SMALL:
			sprite.texture = small_texture
		Size.MEDIUM:
			sprite.texture = medium_texture
		Size.BIG:
			sprite.texture = big_texture
