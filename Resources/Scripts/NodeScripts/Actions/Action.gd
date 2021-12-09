extends Resource

class_name Action, "res://Resources/Images/GUI/SimpleIcons/White/1x/star.png"

var Arena

var OwnCharacter
export (int) var ActionCost = 1
export (int) var Distance = 2
var Target

#func _init():
#
#	pass

func InSelfDistance(distance, targetPosition):
	pass

#Arena.InDistanceCheck(ZonePosition, AttackDistance, target) && ActionPoints > 0
func ActivationCheck(target):
	printt("Arena.InDistanceCheck(OwnCharacter.ZonePosition, Distance, target)", Arena.InDistanceCheck(OwnCharacter.ZonePosition, Distance, target))
	printt("OwnCharacter.ZonePosition", OwnCharacter.ZonePosition, "Distance", Distance, "target", target)
	return OwnCharacter.ActionPoints >= ActionCost && Arena.InDistanceCheck(OwnCharacter.ZonePosition, Distance, target)
	pass

func Activate():
	print("Activate Action")
	OwnCharacter.ActionPoints -= ActionCost
	FightSystem.GetCharacterByPos(OwnCharacter.target).Health -= 5
#	OwnCharacter.Health -= 5
	pass
