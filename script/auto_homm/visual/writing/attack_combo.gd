class_name teVisualWritingAttackCombo extends Resource


@export var trigger := teVisualWriting.ComboTrigger.ATTACK_MODIFIED
@export var count: int = 3


func is_triggered(attack_modified: bool) -> bool:
	if trigger == teVisualWriting.ComboTrigger.ALWAYS:
		return true
	if trigger == teVisualWriting.ComboTrigger.ATTACK_MODIFIED and attack_modified:
		return true
	if trigger == teVisualWriting.ComboTrigger.NO_ATTACK_MODIFIER and not attack_modified:
		return true
	return false
