extends Resource

class_name Action, "res://Resources/Images/GUI/SimpleIcons/White/1x/star.png"

enum {TARGET, POSITION, ZONE}

var Arena

var OwnCharacter
export (int) var ActionCost = 1
export (String, FILE) var IconOpen
export (String, FILE) var IconClose
export (int) var Cooldown = 0
var cooldownTime = 0
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
	return OwnCharacter.ActionPoints >= ActionCost && cooldownTime == 0
	pass

func Activate():
	print("Activate Action")
	OwnCharacter.ActionPoints -= ActionCost
	if Cooldown > 0:
		cooldownTime = Cooldown
#	FightSystem.GetCharacterByPos(OwnCharacter.target).Health -= 5
#	OwnCharacter.Health -= 5
	Unselect()
	pass
