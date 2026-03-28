class_name teUnitVisualsBase extends Node2D


signal windup()


@export var node_to_glow: Node2D


var winding_up: bool = false


func go_idle():
	pass


func _windup_start():
	winding_up = true


func _windup_finish():
	winding_up = false
	windup.emit()
