extends Control

onready var DamageNumbers = preload("res://Resources/Entities/UI/DamageNumbers.tscn")



func _input(event):
	if event is InputEventMouseButton && event.pressed:
#		print("Event1")
		if event.button_index == 1:
#			print("Event2")
			var newNumbers = DamageNumbers.instance()
			add_child(newNumbers)
			newNumbers.rect_position = get_global_mouse_position()
			newNumbers.ShowNumbers()
	pass
