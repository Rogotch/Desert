extends Resource

class_name Action, "res://Resources/Images/GUI/SimpleIcons/White/1x/star.png"

var Arena

var OwnCharacter
export (int) var ActionCost = 1
var Target

#func _init():
#
#	pass

func InSelfDistance(distance, targetPosition):
	pass

#Arena.InDistanceCheck(ZonePosition, AttackDistance, target) && ActionPoints > 0
func ActivationCheck(target):
	return OwnCharacter.ActionPoints >= ActionCost
	pass

func Activate():
	print("Activate Action")
	OwnCharacter.ActionPoints -= ActionCost
#	FightSystem.GetCharacterByPos(OwnCharacter.target).Health -= 5
#	OwnCharacter.Health -= 5
	pass
