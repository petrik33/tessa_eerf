class_name teCombatMovie extends Node


@export var director: teVisualDirector
@export var writer: teVisualWriter


func run(turn: teCombatEventLog):
	director.play(writer.sequence(turn))
