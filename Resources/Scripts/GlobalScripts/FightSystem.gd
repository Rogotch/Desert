extends Node

var SelectedCharacter = null
var PlayerTurn = true

var TurnsQueue = []
var queueIndex = 0

func _ready():
	pass


func StartTurn():
	SelectedCharacter = TurnsQueue[queueIndex]
	TurnsQueue[queueIndex].StartTurn()
	pass

func EndTurn():
	TurnsQueue[queueIndex].EndTurn()
	queueIndex = (queueIndex + 1) % TurnsQueue.size()
	StartTurn()
	pass
