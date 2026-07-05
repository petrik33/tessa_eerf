class_name PixelArt3dBoardTextureRenderer extends Node


signal updated(texture: ViewportTexture)


@export var subviewport: SubViewport


func _ready() -> void:
	await RenderingServer.frame_post_draw
	update()


func update():
	updated.emit(get_texture())


func get_texture() -> ViewportTexture:
	return subviewport.get_texture()
