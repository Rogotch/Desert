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

var ZoneStatus
var AllZones = []
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
	ZoneStatus = status
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
	GetNeighborZones([0, 1, 2], false)
	ZoneEffects.Effects.clear()
	for character in Characters:
#		ZoneEffects.Effects.append_array(character.EmittedEffects.GetEffectsByType(Effect.Type.ZONE))
		# Сначала собираем массив эффектов зональных
		var effects = character.EmittedEffects.GetEffectsByType(Effect.Type.ZONE)
		# А потом в цикле их перебираем и раскидываем по соседним зонам
		for effect in effects:
			var zones = GetNeighborZones(effect.TargetsZones, effect.PlayerEffect)
			for zone in zones:
				zone.SetEffect(effect)
		pass
	
	pass

func GetNeighborZones(zones, mirrorFlag = true):
	var ZonePos = AllZones.find(self)
#	prints("AllZones", AllZones)
#	prints("ZonePos", AllZones.find(self))
	var finalZones = []
	for zoneCount in zones:
		var count = zoneCount
		if count == 0:
			finalZones.append(self)
		else:
			var mod = (2 if mirrorFlag else -2) * count
			if ZonePos + mod >= 0 && ZonePos + mod < AllZones.size():
				finalZones.append(AllZones[ZonePos + mod])
	return finalZones
#	print("Final zones", finalZones)
	pass

func SetEffect(effect):
	PrintZoneInfo()
	PrintEffectInfo(effect)
	if ((effect.ZoneStatus == Effect.ZoneCondition.NONE   && ZoneStatus == NONE)   || # Если зона пустая
		((effect.ZoneStatus == Effect.ZoneCondition.ENEMY && effect.PlayerEffect   || # Или если зона принадлежит противоположной команде
		 effect.ZoneStatus == Effect.ZoneCondition.PLAYER && !effect.PlayerEffect) && 
		ZoneStatus == ENEMY)  ||
		((effect.ZoneStatus == Effect.ZoneCondition.PLAYER && effect.PlayerEffect   || # Или если зона принадлежит союзной команде
		  effect.ZoneStatus == Effect.ZoneCondition.ENEMY && !effect.PlayerEffect)  && 
		ZoneStatus == PLAYER)  ||
		(effect.ZoneStatus == Effect.ZoneCondition.COMMON && ZoneStatus == COMMON)) : # Или если зона смешанная
			ZoneEffects.Effects.append(effect) # то добавь этот эффект к эффектам зоны 
	for character in Characters:
		character.ReceivedEffects.DeleteAllEffectsByType(Effect.Type.ZONE)
		character.ReceivedEffects.Effects.append_array(ZoneEffects.Effects)
		pass
	pass

func PrintZoneInfo():
	var status = ""
	match ZoneStatus:
		NONE:
			status = "NONE"
		PLAYER:
			status = "PLAYER"
		ENEMY:
			status = "ENEMY"
		COMMON:
			status = "COMMON"
	prints("Zone Status", status, "ZoneID", ZoneId)
	pass

func PrintEffectInfo(effect):
	var status = ""
	match effect.ZoneStatus:
		Effect.ZoneCondition.PLAYER:
			status = "PLAYER"
		Effect.ZoneCondition.ENEMY:
			status = "ENEMY"
		Effect.ZoneCondition.COMMON:
			status = "COMMON"
	prints("Effect Status", status, "playerEffect -", effect.PlayerEffect)
	pass
