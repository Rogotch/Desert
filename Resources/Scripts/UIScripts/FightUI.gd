extends Control

export var _UnitUI        : NodePath
export var _ActionsCells  : NodePath
export var UnitUIOffset   : Vector2
onready var UnitUI        = get_node(_UnitUI)
onready var ActionsCells  = get_node(_ActionsCells)

onready var UnitStrings = UnitUI.get_node("Strings")
onready var UnitHP = UnitUI.get_node("Strings/Health")
onready var UnitZP = UnitUI.get_node("Strings/ZonePoints")
onready var UnitMP = UnitUI.get_node("Strings/Movement")
onready var UnitAP = UnitUI.get_node("Strings/ActionPoints")

var SelectedAction = null

func _ready():
	ConnectAllCells()
	pass

func NextTurn():
	FightSystem.EndTurn()
	pass

func _physics_process(_delta):
	if FightSystem.SelectedCharacter != null:
		UnitStrings.rect_position = -UnitStrings.rect_size + UnitUIOffset
		UnitUI.rect_position = get_viewport().get_camera().unproject_position(FightSystem.SelectedCharacter.transform.origin)
		UnitHP.text = "Здоровье               - " + str(FightSystem.SelectedCharacter.Health)
		UnitZP.text = "Зональные Очки   - " + str(FightSystem.SelectedCharacter.ZonePoints)
		UnitMP.text = "Передвижение      - " + str(FightSystem.SelectedCharacter.Movement)
		UnitAP.text = "Очки действий       - " + str(FightSystem.SelectedCharacter.ActionPoints)
	pass

func ConnectAllCells():
	var Cells = ActionsCells.get_children()
	for cell in Cells:
		cell.connect("pressed", self, "SelectCell", [cell])
	pass

func SelectCell(cell):
	if cell != SelectedAction:
		if SelectedAction:
			SelectedAction.Unselect()
		SelectedAction = cell
		cell.Select()
	else:
		SelectedAction.Unselect()
		SelectedAction = null
	pass
