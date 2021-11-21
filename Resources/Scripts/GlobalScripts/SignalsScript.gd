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
	pass
