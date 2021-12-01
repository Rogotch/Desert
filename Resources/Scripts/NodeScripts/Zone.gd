extends Node

class_name Zone, "res://Resources/Images/GUI/SimpleIcons/White/1x/tablet.png"

enum {NONE, INTERZONE, ENEMY, PLAYER, COMMON}

var Arena
var Status = NONE

var ZoneParameters setget SetZoneParams
var ZoneEffects = EffectsHolder.new()

var ZoneName
var ZoneId
var Interzone
var StartPos
var EndPos

var Characters = []
var VisualGrid

func _ready():
	pass # Replace with function body.

func SetZoneParams(params):
#	var params = {ZoneName = "Zone1", ZoneId = 0, StartPos = Vector2(0, 0),  EndPos = Vector2(3,5),  interzone = false}
	ZoneParameters = params
	ZoneName       = params.ZoneName
	ZoneId         = params.ZoneId
	StartPos       = params.StartPos
	EndPos         = params.EndPos
	Interzone      = params.interzone
	ZoneEffects.ZoneObj = self
	pass

func GetAllCharacters():
	Characters.clear()
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
	CheckCondition()
	pass

func CheckSignal(_character, zoneID):
	print("Zone id - " + str(zoneID))
	if zoneID == ZoneId:
		GetAllCharacters()
		call_deferred("CheckCondition")
	pass

# Установка цвета сетки
#		VisualGrid.GridColor = Color.yellow - мгновенная
#		VisualGrid.SetGridColorSmooth(Color.green) - плавная
func CheckCondition():
	print("Check Condition!")
	if !Interzone:
		if Characters.size() == 0:
			SetStatus(NONE)
		else:
			var teamNums = {}
			print("Characters in zone - " + str(Characters.size()))
			for _char in Characters:
				if teamNums.has(_char.PlayerTeam):
					teamNums[_char.PlayerTeam] += 1
				else:
					teamNums[_char.PlayerTeam] = 1
			prints("teamNums", str(teamNums))
			if teamNums.keys().size() > 1:
				SetStatus(COMMON)
			else:
				match teamNums.keys()[0]:
					true:
						SetStatus(PLAYER)
					false:
						SetStatus(ENEMY)
	pass

func SetStatus(status):
	match status:
		NONE:
			VisualGrid.SetGridColorSmooth(Color.white)
			pass
		PLAYER:
			VisualGrid.SetGridColorSmooth(Color.aqua)
			pass
		ENEMY:
			VisualGrid.SetGridColorSmooth(Color.red)
			pass
		COMMON:
			VisualGrid.SetGridColorSmooth(Color.yellow)
			pass
	pass

func UpdateZoneEffects():
	ZoneEffects.Effects.clear()
	for character in Characters:
		ZoneEffects.Effects.append_array(character.EmittedEffects.GetEffectsByType(Effect.Type.ZONE))
		character.ReceivedEffects.DeleteAllEffectsByType(Effect.Type.ZONE)
		pass
	
	for character in Characters:
		character.ReceivedEffects.Effects.append_array(ZoneEffects.Effects)
		pass
	pass
