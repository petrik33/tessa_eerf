class_name CombatVisualUtils extends Object


static func hflip_animated_sprite(sprite: AnimatedSprite2D, flip: bool):
	sprite.scale = Vector2(
		abs(sprite.scale.x) if flip else -abs(sprite.scale.x),
		sprite.scale.y
	)
