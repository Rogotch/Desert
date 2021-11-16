extends StaticBody

signal EndAppear

export var _animPlayer   : NodePath
export var _mesh         : NodePath
onready var Anim    = get_node(_animPlayer)
onready var MeshObj = get_node(_mesh)

var Selected = false
var Selectable = true
var AppearEnd = false

var Arena
func _ready():
	add_to_group("PathTiles")
	MeshObj.get_active_material(0).albedo_color = Color(1,1,1,0)
	Arena = get_tree().get_nodes_in_group("Arena")[0]
	pass

func _appear():
	if Selectable:
		var stepNum = get_meta("moveStep")
#		print("stepNum - " + str(float(stepNum)/10.0))
		yield(get_tree().create_timer(float(stepNum)/10.0), "timeout")
		Anim.play("appear")
		yield(Anim, "animation_finished")
		emit_signal("EndAppear")
		AppearEnd = true
	pass

func _quit():
	Selectable = false
	Anim.play("disappear")
	yield(Anim, "animation_finished")
	if AppearEnd:
#		print("Выход 1")
		queue_free()
	else:
		yield(self, "EndAppear")
#		print("Выход 2")
		queue_free()
	pass

#func Wave():
#	pass

func _on_PathAreaTile_mouse_entered():
	if Selectable:
		Selected = true
		Anim.play("highlight")
	pass # Replace with function body.

func _on_PathAreaTile_mouse_exited():
	if Selectable:
		Selected = false
		Anim.play_backwards("highlight")
	pass # Replace with function body.

func _on_PathAreaTile_input_event(_camera, event, position, _normal, _shape_idx):
	if event is InputEventMouseButton && event.pressed && event.button_index == 1 && Selectable:
		Arena.GoToClick(FightSystem.SelectedCharacter, position)
		Selectable = false
	pass # Replace with function body.
