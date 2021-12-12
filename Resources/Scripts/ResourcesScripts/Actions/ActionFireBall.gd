extends Action

class_name ActionFireBall
#var Arena
#
#var OwnCharacter
#export (int) var ActionCost = 1
export (int) var Radius = 2

#func _init():
#
#	pass

func Select():
	.Select()
	FightSystem.Mode = FightSystem.SelectMode.POSITION
	pass

func InSelfDistance(distance, targetPosition):
	pass

func Activate():
	.Activate()
	var areaCharacters = Arena.GetCharactersInPointsArray(Arena.CircleArea(Target, Radius))
	for character in areaCharacters:
		character.Health -= 3
##	OwnCharacter.Health -= 5
	FightSystem.Mode = FightSystem.SelectMode.NONE
	pass
