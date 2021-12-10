extends Action

class_name ActionFireBall
#var Arena
#
#var OwnCharacter
#export (int) var ActionCost = 1
export (int) var Radius = 2
#var Target

#func _init():
#
#	pass

func InSelfDistance(distance, targetPosition):
	pass

func Activate():
	.Activate()
	var areaCharacters = Arena.GetCharactersInArea(OwnCharacter.target, Radius)
	for character in areaCharacters:
		character.Health -= 3
##	OwnCharacter.Health -= 5
	pass
