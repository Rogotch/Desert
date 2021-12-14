extends Node

signal NewRound(roundNum)
signal StartTurn(character)
signal EndTurn

enum SelectMode {NONE, TARGET, POSITION, ZONE}

var Arena
var SelectedCharacter = null
var PlayerTurn = true
var Mode = SelectMode.NONE

var TurnsQueue = []
var queueIndex = 0
var roundCounter = 0


func _ready():
	pass


func StartTurn():
	SelectedCharacter = TurnsQueue[queueIndex]
	TurnsQueue[queueIndex].StartTurn()
	if queueIndex == 0:
		roundCounter += 1
		emit_signal("NewRound", roundCounter)
	emit_signal("StartTurn", SelectedCharacter)
#	var zone = Arena.GetZoneByID(ZoneId)
#	zone.GetAllCharacters()
	pass

func EndTurn():
	yield(get_tree(), "idle_frame")
	TurnsQueue[queueIndex].EndTurn()
	queueIndex = (queueIndex + 1) % TurnsQueue.size()
	get_tree().call_group("Cells", "ClearIcon")
	emit_signal("EndTurn")
	call_deferred("StartTurn")
#	StartTurn()
	pass

func GetCharacterByPos(position):
	return Arena.Grid[position.x][position.y].character
	pass
