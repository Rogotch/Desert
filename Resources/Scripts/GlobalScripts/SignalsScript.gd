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

func _ready():
	connect("CameOnZone", self, "CheckSignal1")
	connect("LeftTheZone", self, "CheckSignal2")
#	connect("StartTurnOnZone", self, "CheckSignal3")
#	connect("EndTurnOnZone", self, "CheckSignal4")
	pass

func CheckSignal1(character, ZoneID):
	print("Сигнал CameOnZone работает")
	print("Зона " + str(ZoneID))
	pass

func CheckSignal2(character, ZoneID):
	print("Сигнал LeftTheZone работает")
	print("Зона " + str(ZoneID))
	pass
#
#func CheckSignal3(character, ZoneID):
#	print("Сигнал StartTurnOnZone работает")
#	pass
#
#func CheckSignal4(character, ZoneID):
#	print("Сигнал EndTurnOnZone работает")
#	pass
