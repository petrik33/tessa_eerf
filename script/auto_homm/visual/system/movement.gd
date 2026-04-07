class_name teVisualMovementSystem extends Node


func follow_path(node: Node2D, path: Array[Vector2], time_sec: float):
	if path.size() < 2:
		return

	var total_length := 0.0
	for i in range(1, path.size()):
		total_length += path[i - 1].distance_to(path[i])

	if total_length == 0:
		return

	for i in range(1, path.size()):
		var from := node.position
		var to := path[i]

		var segment_length := from.distance_to(to)
		if segment_length == 0:
			continue

		var duration := time_sec * (segment_length / total_length)

		var elapsed := 0.0
		while elapsed < duration:
			var t := elapsed / duration
			node.position = from.lerp(to, t)
			await get_tree().process_frame
			elapsed += get_process_delta_time()

		node.position = to
