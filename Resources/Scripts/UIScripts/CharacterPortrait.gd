extends Control

export (NodePath) var _Icon
onready var Icon = get_node(_Icon)

var SelectedCharacter = null

#func _init(character):
#	SelectedCharacter = character
#	pass
#func SelectCharacter()

func Update():
	Icon.set_texture(load(SelectedCharacter.CharacterIcon))
	pass
