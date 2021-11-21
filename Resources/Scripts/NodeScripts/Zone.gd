extends Node

class_name Zone, "res://Resources/Images/GUI/SimpleIcons/White/1x/tablet.png"

enum {NONE, INTERZONE, FRIEND, ENEMY, PLAYER}

var Arena
var Status = NONE

var ZoneParameters setget SetZoneParams

var ZoneName
var ZoneId
var Interzone
var StartPos
var EndPos

var Characters = []
var VisualGrid

func _ready():
	SignalsScript.connect("CameOnZone",  self, "CheckSignal")
	SignalsScript.connect("LeftTheZone", self, "CheckSignal")
	pass # Replace with function body.

func SetZoneParams(params):
#	var params = {ZoneName = "Zone1", ZoneId = 0, StartPos = Vector2(0, 0),  EndPos = Vector2(3,5),  interzone = false}
	ZoneParameters = params
	ZoneName       = params.ZoneName
	ZoneId         = params.ZoneId
	StartPos       = params.StartPos
	EndPos         = params.EndPos
	Interzone      = params.interzone
	pass

func GetAllCharacters():
#	Characters.clear()
	var grid = Arena.Grid
	var XCount = StartPos.x
	var YCount = StartPos.y
	
	# Перебираем все клетки массива в поисках персонажей
	while XCount < EndPos.x:
		while YCount < EndPos.y:
			if grid[XCount][YCount].content == GridPoint.CHARACTER:
				Characters.append(grid[XCount][YCount].character)
			YCount += 1
		YCount = StartPos.y
		XCount += 1
	pass

func CheckSignal(_character, zoneID):
	if zoneID == ZoneId:
		GetAllCharacters()
	pass
