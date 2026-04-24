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
	created.append(projectile)
	
	projectile.attach_visuals(visual_scene.instantiate())
	projectile.trajectory = trajectory
	projectile.position = origin
	
	return projectile


func shoot(uid: StringName, origin: Vector2, target: Vector2, speed_multiplier: float = 1.0) -> bool:
	var visual_scene: PackedScene = scenes.get(uid)
	if not visual_scene:
		return false
	
	var trajectory := trajectories[teVisualProjectileTrajectory.STRAIGHT]
	var projectile := projectile_scene.instantiate() as teVisualProjectileNode2D
	
	group_node.add_child(projectile)
	created.append(projectile)
	
	projectile.attach_visuals(visual_scene.instantiate())
	projectile.trajectory = trajectory
	projectile.position = origin
	
	await projectile.shoot(target, speed_multiplier)
	
	projectile.queue_free()
	
	return true


func estimate_shot_duration(_uid: StringName, origin: Vector2, target: Vector2) -> float:
	var trajectory := trajectories[teVisualProjectileTrajectory.STRAIGHT]
	var base_anim_duration := trajectory.animation.length
	var anim_scale := (target - origin).length() / teVisualProjectileNode2D.BASE_TRAJECTORY_LENGTH
	return base_anim_duration * anim_scale


func destroy(projectile: teVisualProjectileNode2D):
	var id := created.find(projectile)
	if id == -1:
		return
	group_node.remove_child(projectile)
	created.remove_at(id)
	projectile.queue_free()
