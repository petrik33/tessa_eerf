@tool
class_name HexUtils

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")
	
const HEX_AXIAL_FORMAT = "%s:%s"
const HEX_CUBE_FORMAT = "%s:%s:%s"

static func axial_format(hex: Vector2i) -> String:
	return HEX_AXIAL_FORMAT % [hex.x, hex.y]
	
static func cube_format(hex: Vector2i) -> String:
	return HEX_CUBE_FORMAT % [hex.x, hex.y, -hex.x - hex.y]
