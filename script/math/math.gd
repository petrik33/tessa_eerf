@tool
class_name Math

func _init() -> void:
	Utils.assert_static_lib()


const INT_MAX := 9223372036854775807


static func random_point_inside_triangle2d(rng: RandomNumberGenerator, a: Vector2, b: Vector2, c: Vector2) -> Vector2:
	var r1 = sqrt(rng.randf())
	var r2 = rng.randf()
	return (1.0 - r1) * a + r1 * (1.0 - r2) * b + r1 * r2 * c


static func random_point_inside_triangle3d(rng: RandomNumberGenerator, a: Vector3, b: Vector3, c: Vector3) -> Vector3:
	var r1 = sqrt(rng.randf())
	var r2 = rng.randf()
	return (1.0 - r1) * a + r1 * (1.0 - r2) * b + r1 * r2 * c


static func clip_polygon_bottom_percent_halfplane(polygon: PackedVector2Array, percent: float) -> PackedVector2Array:
	var top_y := 1e9
	var bottom_y := -1e9
	for v in polygon:
		if v.y < top_y:
			top_y = v.y
		if v.y > bottom_y:
			bottom_y = v.y
	if top_y > bottom_y:
		top_y = bottom_y
	var height := bottom_y - top_y
	if height <= 0:
		return polygon
	var threshold := bottom_y - percent * height
	return clip_polygon_bottom_halfplane(polygon, threshold)


static func clip_polygon_bottom_halfplane(polygon: PackedVector2Array, threshold: float) -> PackedVector2Array:
	var out := PackedVector2Array()
	var n := polygon.size()
	if n == 0:
		return out
	for i in range(n):
		var a := polygon[i]
		var b := polygon[(i + 1) % n]
		var a_in := a.y >= threshold
		var b_in := b.y >= threshold
		if a_in and b_in:
			out.append(b)
		elif a_in and not b_in:
			var t := (threshold - a.y) / (b.y - a.y)
			var ix := a.x + t * (b.x - a.x)
			out.append(Vector2(ix, threshold))
		elif not a_in and b_in:
			var t := (threshold - a.y) / (b.y - a.y)
			var ix := a.x + t * (b.x - a.x)
			out.append(Vector2(ix, threshold))
			out.append(b)
	return out
