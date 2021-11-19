extends Node

class_name GridPoint, "res://Resources/Images/GUI/SimpleIcons/White/1x/target.png"

enum {EMPTY = 0, CHARACTER = 1, OBSTACLE = 2, OUTZONE = 3}

var step = null
var content = EMPTY
var zoneID
var interzoneFlag = false

func _ready():
	add_to_group("GridPoints")
	pass

func ClearPoint():
#	print("CLEAR")
	step = null
	pass

#Проверка возможности прохождения через эту клетку персонажем
func CheckMovement(_character, lastPointsCost):
	var potentialMovement = _character.Speed * _character.ActionPoints + _character.Movement
	
#	Если это межзонье, но у игрока есть и пункты движения и пункты перехода между зонами
	if interzoneFlag && _character.ZonePoints > lastPointsCost.zonePoints && potentialMovement > lastPointsCost.movement:
#		То увеличь в стоимости пути количество необходимых пунктов межзония, не меняя при этом пункты движения
		lastPointsCost.zonePoints += 1
#		Верни истину, если у персонажа ещё есть очки передвижения и ложь в обратном случае
		return (potentialMovement > lastPointsCost.movement)
	else:
#		Если это межзонье, но у игрока нет очков перехода между зонами, то верни ложь
		if interzoneFlag && _character.ZonePoints <= lastPointsCost.zonePoints:
			return false
		else:
#			Если это межзонье, верни ложь
			if interzoneFlag:
				return false
			else:
#				Иначе верни результат в зависимости от того, достаточно ли у игрока очков передвижения и увеличь стоимость передвижения на 1
				lastPointsCost.movement += 1
				return (potentialMovement >= lastPointsCost.movement)
	pass

func OnCellStart():
	pass

func OnCellEnd():
	pass

func OnCellMove(_Character):
	if interzoneFlag:
		_Character.ZonePoints -= 1
	else:
		if !_Character.freeMovement:
			if _Character.Movement == 0 && _Character.ActionPoints > 0:
				_Character.ActionPoints -= 1
				_Character.Movement = _Character.Speed
			_Character.Movement -= 1
	pass
