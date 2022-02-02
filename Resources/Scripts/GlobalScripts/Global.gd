extends Node

signal timeout

func _ready():
	pass

#func GetRoundPo2DPositionsBy

func _create_timer(value):
	yield(get_tree().create_timer(value), "timeout")
	emit_signal("timeout")
	pass


func ChaikinAlgorithmMultipleIterations(pointArr, iterationsCount):
	for i in iterationsCount:
		pointArr = ChaikinAlgorithm(pointArr)
	return pointArr
	pass

func ChaikinAlgorithm(pointArr):
	var newArr = []
	var count = 0
	newArr.append(pointArr[0])
	for i in pointArr.size():
		if count != pointArr.size() - 1:
			newArr.append((pointArr[i] / 4 * 3) + (pointArr[i + 1] / 4))
			newArr.append((pointArr[i] / 4) + (pointArr[i + 1] / 4 * 3))
		count += 1
	newArr.append(pointArr[count-1])
	return newArr
	pass
	pass
