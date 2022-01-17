extends Control

export (NodePath) var _Target
onready var Target = get_node(_Target)

func _physics_process(delta):
	rect_position = get_viewport().get_camera().unproject_position(Target.transform.origin)
	pass
