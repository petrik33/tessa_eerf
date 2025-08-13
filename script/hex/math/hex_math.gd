@tool
class_name HexMath

func _init() -> void:
	assert(false, "Static lib shouldn't be constructed")

const NEIGHBOR_DIRECTION = [
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
