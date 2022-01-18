extends Node

signal timeout

func _ready():
	pass

#func GetRoundPo2DPositionsBy

func _create_timer(value):
	yield(get_tree().create_timer(value), "timeout")
	emit_signal("timeout")
	pass
