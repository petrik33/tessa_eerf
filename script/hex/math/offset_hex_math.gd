@tool
class_name OffsetHexMath

# Constants
const EVENR_NEIGHBOR_DIRECTION = [
	# even rows
	[Vector2i(+1,  0), Vector2i(+1, -1), Vector2i(0, -1),
	 Vector2i(-1,  0), Vector2i(0, +1), Vector2i(+1, +1)],
	# odd rows
	[Vector2i(+1,  0), Vector2i(0, -1), Vector2i(-1, -1),
	 Vector2i(-1,  0), Vector2i(-1, +1), Vector2i(0, +1)],
]

const EVENQ_NEIGHBOR_DIRECTION = [
	# even columns
	[Vector2i(+1, +1), Vector2i(+1,  0), Vector2i(0, -1),
	 Vector2i(-1,  0), Vector2i(-1, +1), Vector2i(0, +1)],
	# odd columns
	[Vector2i(+1,  0), Vector2i(+1, -1), Vector2i(0, -1),
	 Vector2i(-1, -1), Vector2i(-1,  0), Vector2i(0, +1)],
]

const ODDR_NEIGHBOR_DIRECTION = [
	# even rows
	[Vector2i(+1,  0), Vector2i(0, -1), Vector2i(-1, -1),
	 Vector2i(-1,  0), Vector2i(-1, +1), Vector2i(0, +1)],
	# odd rows
	[Vector2i(+1,  0), Vector2i(+1, -1), Vector2i(0, -1),
	 Vector2i(-1,  0), Vector2i(0, +1), Vector2i(+1, +1)],
]

const ODDQ_NEIGHBOR_DIRECTION = [
	# even columns
	[Vector2i(+1,  0), Vector2i(+1, -1), Vector2i(0, -1),
	 Vector2i(-1, -1), Vector2i(-1,  0), Vector2i(0, +1)],
	# odd columns
	[Vector2i(+1, +1), Vector2i(+1,  0), Vector2i(0, -1),
	 Vector2i(-1,  0), Vector2i(-1, +1), Vector2i(0, +1)],
]

# Even-R
static func evenr_neighbor(hex: Vector2i, direction: int) -> Vector2i:
	var parity = hex.y & 1
	return hex + EVENR_NEIGHBOR_DIRECTION[parity][direction]

static func evenr_to_axial(hex: Vector2i) -> Vector2i:
	var q = hex.x - (hex.y + (hex.y & 1)) / 2
	return Vector2i(q, hex.y)

static func axial_to_evenr(hex: Vector2i) -> Vector2i:
	var col = hex.x + (hex.y + (hex.y & 1)) / 2
	return Vector2i(col, hex.y)

# Even-Q
static func evenq_neighbor(hex: Vector2i, direction: int) -> Vector2i:
	var parity = hex.x & 1
	return hex + EVENQ_NEIGHBOR_DIRECTION[parity][direction]

static func evenq_to_axial(hex: Vector2i) -> Vector2i:
	var q = hex.x
	var r = hex.y - (hex.x + (hex.x & 1)) / 2
	return Vector2i(q, r)

static func axial_to_evenq(hex: Vector2i) -> Vector2i:
	var row = hex.y + (hex.x + (hex.x & 1)) / 2
	return Vector2i(hex.x, row)

# Odd-R
static func oddr_neighbor(hex: Vector2i, direction: int) -> Vector2i:
	var parity = hex.y & 1
	return hex + ODDR_NEIGHBOR_DIRECTION[parity][direction]

static func oddr_to_axial(hex: Vector2i) -> Vector2i:
	var q = hex.x - (hex.y - (hex.y & 1)) / 2
	return Vector2i(q, hex.y)

static func axial_to_oddr(hex: Vector2i) -> Vector2i:
	var col = hex.x + (hex.y - (hex.y & 1)) / 2
	return Vector2i(col, hex.y)

# Odd-Q
static func oddq_neighbor(hex: Vector2i, direction: int) -> Vector2i:
	var parity = hex.x & 1
	return hex + ODDQ_NEIGHBOR_DIRECTION[parity][direction]

static func oddq_to_axial(hex: Vector2i) -> Vector2i:
	var q = hex.x
	var r = hex.y - (hex.x - (hex.x & 1)) / 2
	return Vector2i(q, r)

static func axial_to_oddq(hex: Vector2i) -> Vector2i:
	var row = hex.y + (hex.x - (hex.x & 1)) / 2
	return Vector2i(hex.x, row)
