extends Node

var Arena
var SelectedCharacter = null
var PlayerTurn = true

var TurnsQueue = []
var queueIndex = 0

func _ready():
	pass


func StartTurn():
	SelectedCharacter = TurnsQueue[queueIndex]
	TurnsQueue[queueIndex].StartTurn()
#	var zone = Arena.GetZoneByID(ZoneId)
#	zone.GetAllCharacters()
	pass

func EndTurn():
	yield(get_tree(), "idle_frame")
	TurnsQueue[queueIndex].EndTurn()
	queueIndex = (queueIndex + 1) % TurnsQueue.size()
	call_deferred("StartTurn")
#	StartTurn()
	pass
