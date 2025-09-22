class_name CombatVisualUtils extends Object


static func node_face_hdirection(node: Node2D, direction: Vector2):
	node_hflip(node, cos(direction.angle()) > 0)


static func node_hflip(node: Node2D, face_right: bool):
	"""Flip Node2D horizontally based on direction"""
	node.scale.x = abs(node.scale.x) if face_right else -abs(node.scale.x)
