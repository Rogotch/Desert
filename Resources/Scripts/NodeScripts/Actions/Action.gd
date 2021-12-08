extends Node

class_name Action, "res://Resources/Images/GUI/SimpleIcons/White/1x/star.png"

var Arena
var OwnCharacter
var ActionCost
var Distance
var Target

func _ready():
	Arena = FightSystem.Arena
	pass

func InSelfDistance(distance, targetPosition):
	
	pass

#Arena.InDistanceCheck(ZonePosition, AttackDistance, target) && ActionPoints > 0
func ActivationCheck():
	return OwnCharacter.ActionPoints >= ActionCost
	pass
