class_name teCombatDamageInstance extends Resource


@export var source_unit_id: int
@export var target_unit_id: int
@export var type := teCombatDamage.TYPE
@export var tags := TagSet.new()
@export var base_amount := 0.0

var modified_amount := 0.0
var final_amount := 0.0
var dealt_amount := 0.0

var can_crit := false
var can_dodge := false
var can_lifesteal := false
var can_trigger_on_hit := false

var critted := false
var dodged := false
var blocked := false
