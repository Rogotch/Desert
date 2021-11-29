extends Node

signal CameOnPosition(character, position)
signal LeftThePosition(character, position)
signal StartTurnOnPosition(character, position)
signal EndTurnOnPosition(character, position)
signal CameOnZone(character, ZoneID)
signal LeftTheZone(character, ZoneID)
signal StartTurnOnZone(character, ZoneID)
signal EndTurnOnZone(character, ZoneID)
signal Attack(attacked, attacking)
signal TakingDamage(character)
signal ZoneEffectsActivate
signal UpdateZoneEffects

func _ready():
	connect("CameOnZone", self, "UpdateZonesEffects")
	connect("LeftTheZone", self, "UpdateZonesEffects")
	connect("StartTurnOnZone", self, "UpdateZonesEffects")
	connect("EndTurnOnZone", self, "UpdateZonesEffects")
	connect("UpdateZoneEffects", self, "CheckSignal3")
#	connect("StartTurnOnZone", self, "CheckSignal3")
#	connect("EndTurnOnZone", self, "CheckSignal4")
	pass

func UpdateZonesEffects(_character, _ZoneID):
	emit_signal("UpdateZoneEffects")
	pass

func CheckSignal1(character, ZoneID):
	print("Сигнал CameOnZone работает")
	print("Зона " + str(ZoneID))
	pass

func CheckSignal2(character, ZoneID):
	print("Сигнал LeftTheZone работает")
	print("Зона " + str(ZoneID))
	pass


func CheckSignal3():
	print("Обновление всех зональных эффектов")
	pass
#
#func CheckSignal4(character, ZoneID):
#	print("Сигнал EndTurnOnZone работает")
#	pass
