@tool
extends CombatVisualUnit


@export var arrow_pscene: PackedScene
@export var shooting_yoffset: float
@export_range(0, 360, 0.1, "radians_as_degrees") var max_shooting_rotation: float

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@onready var arrow_origin: Marker2D = %ArrowOrigin
@onready var idle_offset: Marker2D = %IdleOffset
@onready var ranged_offset: Marker2D = %RangedOffset

@onready var walk_along_path: CombatVisualUnitWalkAlongPath = %WalkAlongPath
@onready var face_walk_direction: CombatVisualUnitFaceWalkDirection = %FaceWalkDirection


func idle(action: CombatVisualUnitActionGoIdle):
	CombatVisualUtils.node_face_hdirection(animated_sprite, action.enemy_direction)
	go_idle()
	animated_sprite.rotation = 0


func walk(action: CombatVisualUnitActionWalk):
	animated_sprite.play("walk")
	face_walk_direction.set_process(true)
	await walk_along_path.walk(action)
	face_walk_direction.set_process(false)
	go_idle()


func ranged(action: CombatVisualUnitActionRanged):
	var shooting_target = action.target
	shooting_target.y += arrow_origin.position.y + shooting_yoffset
	
	var direction = (shooting_target - physical_node.position).normalized()
	var target_rotation = atan2(direction.y, abs(direction.x))
	target_rotation = clamp(target_rotation, -max_shooting_rotation, max_shooting_rotation)
	
	CombatVisualUtils.node_face_hdirection(animated_sprite, direction)
	animated_sprite.rotation = target_rotation * animated_sprite.scale.x
	animated_sprite.position = -ranged_offset.position * animated_sprite.scale 
	
	animation_player.play("ranged")


func projectile(_id: StringName) -> CombatVisualProjectile:
	var arrow = arrow_pscene.instantiate() as CombatVisualProjectile
	arrow.global_position = arrow_origin.global_position
	return arrow


func go_idle():
	animated_sprite.play("idle")
	animated_sprite.position = -idle_offset.position * animated_sprite.scale
	animated_sprite.rotation = 0
