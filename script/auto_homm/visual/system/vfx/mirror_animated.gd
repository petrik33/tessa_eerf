@tool
class_name teVisualVfxMirrorAnimated extends teVisualVfxAnimated


@export var mirrored_sprite: AnimatedSprite2D


@export_tool_button("Play")
var test := _test_anim


func play(_params: Dictionary, speed_scale: float):
	super.play(_params, speed_scale)
	mirrored_sprite.play(animation, speed_scale)


func stop():
	super.stop()
	mirrored_sprite.stop()


func _test_anim():
	if mirrored_sprite.is_playing():
		stop()
	else:
		play({}, 1.0)
