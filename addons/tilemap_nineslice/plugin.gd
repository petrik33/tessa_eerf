@tool
extends EditorPlugin

var tool

func _enter_tree():
	tool = preload("res://addons/tilemap_nineslice/nineslice_tool.gd").new()
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, tool)

func _exit_tree():
	remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, tool)
