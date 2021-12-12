extends StaticBody

export  var MarkerPath : NodePath
#export  var PlayerPath : NodePath
export  var GridPath   : NodePath
export  var ArenaPath  : NodePath

onready var Marker = get_node(MarkerPath)
#onready var Player = get_node(PlayerPath)
onready var Grid   = get_node(GridPath)
onready var Arena  = get_node(ArenaPath)

func _ready():
	pass

func _input_event(_camera, event, click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton && event.pressed && !FightSystem.SelectedCharacter.Moving:
		if event.button_index == 1:
			var mapPosition = Vector2(Arena.gridMap.world_to_map(click_position).x, Arena.gridMap.world_to_map(click_position).z)
			match FightSystem.Mode:
				FightSystem.SelectMode.TARGET, FightSystem.SelectMode.NONE:
					Arena.GoToClick(FightSystem.SelectedCharacter, click_position)
				FightSystem.SelectMode.POSITION:
					FightSystem.SelectedCharacter.target = mapPosition
					FightSystem.SelectedCharacter.DoSomething()
#
#				FightSystem.TARGET:
	pass
