@tool
class_name HexLayoutMath

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")

const CORNER_NUM := 6
const HEX_ANGLE_STEP := PI / 3.0
const POINTY_TOP_BASE_HEX_ROTATION := PI / 6.0
const FLAT_TOP_BASE_HEX_ROTATION := 0.0

const Q_BASIS_BASE = Vector2(3.0 / 2.0, sqrt(3.0) / 2.0)
const R_BASIS_BASE = Vector2(0.0, sqrt(3.0))

static func axial_basis(rotation_angle: float, offset: Vector2, size: float) -> Transform2D:
	var basis = Transform2D(Q_BASIS_BASE, R_BASIS_BASE, Vector2.ZERO)
	basis = basis.rotated(-rotation_angle) * size
	basis.origin = offset
	return basis
	
static func hex_corner(rotation_angle: float, index: int) -> Vector2:
	return Vector2.from_angle(-rotation_angle - index * HEX_ANGLE_STEP)

static func is_pointy_top(layout: HexLayout) -> bool:
	return is_equal_approx(layout.base_hex_rotation, POINTY_TOP_BASE_HEX_ROTATION)
	
static func is_flat_top(layout: HexLayout) -> bool:
	return is_equal_approx(layout.base_hex_rotation, FLAT_TOP_BASE_HEX_ROTATION)
