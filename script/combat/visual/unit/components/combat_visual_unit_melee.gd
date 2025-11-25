class_name CombatVisualUnitMelee extends CombatVisualUnitActionComponent


@export var animated_sprite: AnimatedSprite2D
@export var animation_name: String = "melee"
@export var hit_frame: int = -1
@export var physical: Node2D


func melee(action: CombatVisualUnitActionMelee):
	CombatVisualUtils.node_face_hdirection(
		animated_sprite,
		action.attacked_position - physical.position
	)
	animated_sprite.play(animation_name)
	
	if hit_frame == -1:
		await animated_sprite.animation_finished
		executed.emit()
		return
	
	while animated_sprite.frame != hit_frame:
		await animated_sprite.frame_changed
	executed.emit()
	await animated_sprite.animation_finished
