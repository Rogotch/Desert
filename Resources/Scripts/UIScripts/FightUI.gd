extends Control

export var _UnitUI : NodePath
export var UnitUIOffset : Vector2
onready var UnitUI = get_node(_UnitUI)
onready var UnitStrings = UnitUI.get_node("Strings")
onready var UnitHP = UnitUI.get_node("Strings/Health")
onready var UnitZP = UnitUI.get_node("Strings/ZonePoints")
onready var UnitMP = UnitUI.get_node("Strings/Movement")
onready var UnitAP = UnitUI.get_node("Strings/ActionPoints")

func _ready():
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
