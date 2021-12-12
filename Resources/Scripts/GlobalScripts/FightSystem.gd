extends Node

enum SelectMode {NONE, TARGET, POSITION, ZONE}

var Arena
var SelectedCharacter = null
var PlayerTurn = true
var Mode = SelectMode.NONE

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

func GetCharacterByPos(position):
	return Arena.Grid[position.x][position.y].character
	pass
