class_name teVisualProjectileSystem extends Node


@export var group_node: Node2D
@export var scenes: Dictionary[StringName, PackedScene]
@export var trajectories: Dictionary[StringName, teVisualProjectileTrajectory]
@export var projectile_scene: PackedScene


var created: Array[teVisualProjectileNode2D]


func count() -> int:
	return created.size()


func last() -> teVisualProjectileNode2D:
	return created.back()


func create(
	uid: StringName,
	origin: Vector2,
	target: Vector2,
	speed_multiplier := 1.0,
	trajectory_name: StringName = teVisualProjectileTrajectory.STRAIGHT
) -> teVisualProjectileNode2D:
	var visual_scene: PackedScene = scenes.get(uid)
	if not visual_scene:
		return null
	
	var trajectory: teVisualProjectileTrajectory = trajectories.get(trajectory_name)
	if not trajectory:
		return null
	
	var projectile := projectile_scene.instantiate() as teVisualProjectileNode2D
	group_node.add_child(projectile)
	
	var visuals := visual_scene.instantiate()
	
	projectile.trajectory = trajectory
	projectile.position = origin
	projectile.shoot(visuals, target - origin, speed_multiplier)

	created.append(projectile)
	
	return projectile


func destroy(projectile: teVisualProjectileNode2D):
	group_node.remove_child(projectile)
	created.erase(projectile)
	projectile.queue_free()
