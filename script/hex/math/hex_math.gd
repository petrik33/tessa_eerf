@tool
class_name HexMath

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")

const NEIGHBOR_DIRECTION: Array[Vector2i] = [
	Vector2i(+1, 0),
	Vector2i(+1, -1),
	Vector2i(0, -1),
	Vector2i(-1, 0),
	Vector2i(-1, +1),
	Vector2i(0, +1)
]

static func neighbor_direction(direction: int) -> Vector2i:
	return NEIGHBOR_DIRECTION[direction]
	
static func neighbor(hex: Vector2i, direction: int) -> Vector2i:
	return hex + neighbor_direction(direction)

static func in_direction(direction: int, length: int) -> Vector2i:
	return neighbor_direction(direction) * length

static func are_neighbors(hexA: Vector2i, hexB: Vector2i) -> bool:
	return distance(hexA, hexB) <= 1

static func is_in_radius(hex: Vector2i, radius: int) -> bool:
	var s = -hex.x - hex.y
	return max(abs(hex.x), abs(hex.y), abs(s)) <= radius
	
static func nearest(frac: Vector2) -> Vector2i:
	var q = frac.x
	var r = frac.y
	var s = -q - r
	var rq = round(q)
	var rr = round(r)
	var rs = round(s)
	var dq = abs(rq - q)
	var dr = abs(rr - r)
	var ds = abs(rs - s)
	if dq > dr and dq > ds:
		rq = -rr - rs
	elif dr > ds:
		rr = -rq - rs
	return Vector2i(rq, rr)
	
static func distance(a: Vector2i, b: Vector2i) -> int:
	return magnitude(a - b)
	
static func magnitude(vec: Vector2i) -> int:
	var dq = abs(vec.x)
	var dr = abs(vec.y)
	var ds = abs(-vec.x - vec.y)
	return max(dq, dr, ds)


static func hex_perimeter_polygon_by_percent(layout: HexLayout, percent: float, corner_idx_offset := 0, inverse := false) -> PackedVector2Array:
	if percent <= 0.0:
		return PackedVector2Array()
	if percent >= 1.0:
		return layout.hex_polygon()
	
	var polygon := PackedVector2Array()
	
	var corner_offset := corner_idx_offset % HexLayoutMath.CORNER_NUM
	
	var radial_angle := percent * PI * 2
	var radial_progress := radial_angle / HexLayoutMath.HEX_ANGLE_STEP
	var corner_radial_progress = floor(radial_progress)
	var segments_filled := (int(corner_radial_progress) % HexLayoutMath.CORNER_NUM) 
	
	for idx in range(segments_filled + 1):
		var corner_idx := corner_offset - idx if inverse else corner_offset + idx
		polygon.append(layout.hex_corner(corner_idx))
	
	var last_corner_idx := corner_offset - segments_filled if inverse else corner_offset + segments_filled
	var next_corner_idx := last_corner_idx -1 if inverse else last_corner_idx + 1
	var line_progress = radial_progress - corner_radial_progress
	
	polygon.append(lerp(layout.hex_corner(last_corner_idx), layout.hex_corner(next_corner_idx), line_progress))
	
	return polygon
