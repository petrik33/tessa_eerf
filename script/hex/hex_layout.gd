@tool
class_name HexLayout extends Resource

@export_range(0, 360, 0.1, "radians_as_degrees") var base_hex_rotation := POINTY_TOP_BASE_HEX_ROTATION:
	set(value):
		base_hex_rotation = value
		_recalc()
		emit_changed()

@export var size := Vector2(16, 16):
	set(new_size):
		size = new_size
		_recalc()
		emit_changed()


const CORNER_NUM := 6
const HEX_ANGLE_STEP := PI / 3.0
const POINTY_TOP_BASE_HEX_ROTATION := PI / 6.0
const FLAT_TOP_BASE_HEX_ROTATION := 0.0

const Q_BASIS_BASE = Vector2(3.0 / 2.0, sqrt(3.0) / 2.0)
const R_BASIS_BASE = Vector2(0.0, sqrt(3.0))


func is_pointy_top() -> bool:
	return is_equal_approx(base_hex_rotation, POINTY_TOP_BASE_HEX_ROTATION)
	
func is_flat_top() -> bool:
	return is_equal_approx(base_hex_rotation, FLAT_TOP_BASE_HEX_ROTATION)

func hexagon2d(hex: Vector2) -> Hexagon2D:
	var hexagon := Hexagon2D.new()
	var origin := hex_to_pixel(hex)
	hexagon.origin = origin
	hexagon.a = origin + hex_corner(0)
	hexagon.b = origin + hex_corner(1)
	hexagon.c = origin + hex_corner(2)
	return hexagon

func hex_corner(corner: int) -> Vector2:
	var corner_idx := corner % CORNER_NUM
	if corner_idx < 0:
		corner_idx = CORNER_NUM + corner_idx
	return _hex_corner_offset[corner_idx]

func hex_pixel_bounds(hex := Vector2i.ZERO) -> Rect2:
	var bounds = _hex_pixel_bounds
	bounds.position += hex_to_pixel(hex)
	return bounds

func hex_polygon(offset := Vector2.ZERO) -> PackedVector2Array:
	var polygon := PackedVector2Array()
	polygon.resize(CORNER_NUM + 1)
	for i in range(CORNER_NUM):
		polygon[i] = offset + hex_corner(i)
	polygon[CORNER_NUM] = offset + hex_corner(0)
	return polygon

func hex_polygon_at(hex: Vector2i) -> PackedVector2Array:
	var center = hex_to_pixel(hex)
	return hex_polygon(center)

func hex_to_pixel(hex: Vector2i) -> Vector2:
	return _axial_basis * Vector2(hex)

func pixel_to_hex(point: Vector2) -> Vector2i:
	return HexMath.nearest(_inverse_axial_basis * point)

func hex_path_to_pixel(hex: Array[Vector2i]) -> Array[Vector2]:
	return Utils.to_typed(TYPE_VECTOR2, hex.map(func (point: Vector2i): return hex_to_pixel(point)))

func point_on_outline(angle: float) -> Vector2:
	var radial_progress := angle / HEX_ANGLE_STEP
	var corner_radial_progress = floor(radial_progress)
	var corner_idx := int(corner_radial_progress) % CORNER_NUM
	var next_corner_idx := (corner_idx + 1) % CORNER_NUM
	var line_progress = radial_progress - corner_radial_progress
	return lerp(hex_corner(corner_idx), hex_corner(next_corner_idx), line_progress)


var _hex_corner_offset := PackedVector2Array()
var _hex_pixel_bounds: Rect2

var _axial_basis: Transform2D
var _inverse_axial_basis: Transform2D


func _init():
	_hex_corner_offset.resize(CORNER_NUM)
	_recalc()

func _recalc():
	var unit_basis := Transform2D(Q_BASIS_BASE, R_BASIS_BASE, Vector2.ZERO)
	_axial_basis = unit_basis.rotated(-base_hex_rotation).scaled(size)
	_inverse_axial_basis = _axial_basis.affine_inverse()
	_hex_pixel_bounds = Rect2(Vector2.ZERO, Vector2.ZERO)
	for i in range(CORNER_NUM):
		var unit_corner := Vector2.from_angle(-base_hex_rotation - i * HEX_ANGLE_STEP)
		var offset = Vector2(unit_corner.x * size.x, unit_corner.y * size.y)
		_hex_corner_offset[i] = offset
		_hex_pixel_bounds = _hex_pixel_bounds.expand(offset)
