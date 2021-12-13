extends Control

signal Select(cell)
signal pressed

export (NodePath) var _IconNode
onready var IconNode = get_node(_IconNode)

export (NodePath) var _ButtonNode
onready var ButtonNode = get_node(_ButtonNode)

export (NodePath) var _CellAnimation
onready var CellAnimation = get_node(_CellAnimation)

var Icon setget SetIcon

func _ready():
	add_to_group("Cells")
	pass

func SetIcon(newIcon : Texture):
	IconNode.texture = newIcon
	pass

func Select():
	CellAnimation.play("Select")
	emit_signal("Select", self)
	pass

func Unselect():
	CellAnimation.play_backwards("Select")
	pass

func _on_CellButton_pressed():
	emit_signal("pressed")
	pass # Replace with function body.
