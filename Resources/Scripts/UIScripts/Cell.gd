extends Control

signal Select(cell)
signal pressed

export (NodePath) var _IconNode
onready var IconNode = get_node(_IconNode)

export (NodePath) var _CounterLabel
onready var CounterLabel = get_node(_CounterLabel)

export (NodePath) var _ButtonNode
onready var ButtonNode = get_node(_ButtonNode)

export (NodePath) var _CellAnimation
onready var CellAnimation = get_node(_CellAnimation)

var Icon setget SetIcon

var DisabledAction = false setget DisableAction

var CellAction = null
var Disabled = false

func _ready():
	add_to_group("Cells")
	pass

func SetActionParams(action):
	SetIcon(load(action.IconOpen))
	DisableAction(action.cooldownTime > 0)
	if action.cooldownTime > 0:
		CounterLabel.LabelText = action.cooldownTime
	else:
		CounterLabel.LabelText = ""
	CellAction = action
	pass

func ClearActionParams():
	SetIcon(null)
	CounterLabel.LabelText = ""
	CellAction = null
	pass

func SetIcon(newIcon : Texture):
	IconNode.texture = newIcon
	pass

func DisableAction(flag):
	var shader_material = IconNode.get_material()
	shader_material.set_shader_param("GrayScale", flag)
	pass

func ClearIcon():
	IconNode.texture = null
	pass

func Select():
	CellAnimation.play("Select")
	emit_signal("Select", self)
	pass

func Unselect():
	CellAnimation.play_backwards("Select")
	pass

func _on_CellButton_pressed():
	if !Disabled:
		emit_signal("pressed")
	pass # Replace with function body.

func _change_disabled(flag):
	Disabled = flag
	if flag:
		modulate = Color.gray
	else:
		modulate = Color.white
