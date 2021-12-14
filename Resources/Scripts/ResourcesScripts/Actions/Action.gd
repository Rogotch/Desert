extends Resource

class_name Action, "res://Resources/Images/GUI/SimpleIcons/White/1x/star.png"

enum {TARGET, POSITION, ZONE}

var Arena

var OwnCharacter
export (int) var ActionCost = 1
export (String, FILE) var IconOpen
export (String, FILE) var IconClose
var Target

#func _init():
#
#	pass

func Select():
	FightSystem.Mode = FightSystem.SelectMode.TARGET
	OwnCharacter.SelectedAction = self
	pass

func Unselect():
	FightSystem.Mode = FightSystem.SelectMode.NONE
	OwnCharacter.SelectedAction = null
	pass

func InSelfDistance(distance, targetPosition):
	pass

#Arena.InDistanceCheck(ZonePosition, AttackDistance, target) && ActionPoints > 0
func ActivationCheck(target):
	Target = target
	return OwnCharacter.ActionPoints >= ActionCost
	pass

func Activate():
	print("Activate Action")
	OwnCharacter.ActionPoints -= ActionCost
#	FightSystem.GetCharacterByPos(OwnCharacter.target).Health -= 5
#	OwnCharacter.Health -= 5
	Unselect()
	pass
