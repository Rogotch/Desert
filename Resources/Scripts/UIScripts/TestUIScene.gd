extends Control

onready var DamageNumbers = preload("res://Resources/Entities/UI/DamageNumbers.tscn")
var rng = RandomNumberGenerator.new()


func _input(event):
	if event is InputEventMouseButton && event.pressed:
#		print("Event1")
		if event.button_index == 1:
#			print("Event2")
			rng.randomize()
			var randValue = rng.randi()%10 + 1
			var newNumbers = DamageNumbers.instance()
			add_child(newNumbers)
			newNumbers.rect_position = get_global_mouse_position()
			newNumbers.ShowNumbers(randValue)
	pass
