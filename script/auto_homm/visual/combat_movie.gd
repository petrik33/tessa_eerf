class_name teCombatMovie extends Node


@export var board: teBoardVisual
@export var director: teVisualDirector
@export var writer: teVisualWriter


func run(turn: teCombatEventLog):
	director.play(board, writer.sequence(turn))
