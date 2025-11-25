
@tool
extends CombatVisualUnit


@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var walk_along_path: CombatVisualUnitWalkAlongPath = %WalkAlongPath
@onready var face_walk_direction: CombatVisualUnitFaceWalkDirection = %FaceWalkDirection
@onready var melee_component: CombatVisualUnitMelee = %Melee
@onready var hurt_flash: CombatVisualUnitHitFlash = %HurtFlash

func idle(action: CombatVisualUnitActionGoIdle):
	go_idle()
	CombatVisualUtils.node_face_hdirection(animated_sprite, action.enemy_direction)


func walk(action: CombatVisualUnitActionWalk):
	animated_sprite.play("walk")
	face_walk_direction.set_process(true)
	await walk_along_path.walk(action)
	face_walk_direction.set_process(false)
	go_idle()


func hurt(_action: CombatVisualUnitActionHurt):
	await hurt_flash.flash()


func melee(action: CombatVisualUnitActionMelee):
	await melee_component.melee(action)
	go_idle()


func go_idle():
	animated_sprite.play("idle")
