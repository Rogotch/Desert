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
var SelectedCharacter = null

func _ready():
	ConnectAllCells()
	FightSystem.connect("EndTurn", self, "ClearCells")
	FightSystem.connect("StartTurn", self, "FillCells")
	SignalsScript.connect("DoAction", self, "UnselectActivedAction")
	SignalsScript.connect("UpdateFightUI", self, "UpdateCells")
	pass

func UnselectActivedAction(_character, action_id):
	if SelectedAction:
		SelectedAction.Unselect()
		SelectedAction = null
	pass

func NextTurn():
	FightSystem.EndTurn()
	pass

func _physics_process(_delta):
	if FightSystem.SelectedCharacter != null:
		UnitStrings.rect_position = -UnitStrings.rect_size + UnitUIOffset
		UnitUI.rect_position = get_viewport().get_camera().unproject_position(FightSystem.SelectedCharacter.transform.origin)
		UnitHP.text = "Здоровье                 - " + str(FightSystem.SelectedCharacter.Health) + "/" + str(FightSystem.SelectedCharacter.Constitution)
		UnitZP.text = "Зональные Очки   - " + str(FightSystem.SelectedCharacter.ZonePoints)
		UnitMP.text = "Передвижение      - " + str(FightSystem.SelectedCharacter.Movement)
		UnitAP.text = "Очки действий       - " + str(FightSystem.SelectedCharacter.ActionPoints)
	pass

func FillCells(character):
	SelectedCharacter = character
	var count = 0
	for cell in ActionsCells.get_children():
		if count < character.Actions.size() :
#			cell.Icon = load(character.Actions[count].IconOpen)
			cell.SetActionParams(character.Actions[count])
			cell._change_disabled(false)
		else:
			cell.ClearActionParams()
			cell._change_disabled(true)
		count += 1
	pass

func UpdateCells():
	if SelectedCharacter:
		FillCells(SelectedCharacter)
	pass

func ClearCells():
	SelectedCharacter = null
	if SelectedAction:
		SelectedAction.Unselect()
		SelectedAction = null
	for cell in ActionsCells.get_children():
		cell._change_disabled(true)
		cell.ClearIcon()
	pass

func ConnectAllCells():
	var Cells = ActionsCells.get_children()
	for cell in Cells:
		cell.connect("pressed", self, "SelectCell", [cell])
		cell.connect("Select", self, "CellSelected")
	pass

func SelectCell(cell):
	if cell != SelectedAction:
		if SelectedAction:
			if SelectedCharacter:
				SelectedCharacter.Actions[SelectedAction.get_index()].Unselect()
			SelectedAction.Unselect()
		SelectedAction = cell
		cell.Select()
	else:
		if SelectedCharacter:
			SelectedCharacter.Actions[SelectedAction.get_index()].Unselect()
		SelectedAction.Unselect()
		SelectedAction = null
	pass

func CellSelected(cell):
	prints("index - ", cell.get_index())
	if SelectedCharacter:
		SelectedCharacter.Actions[cell.get_index()].Select()
	pass
