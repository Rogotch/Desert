extends StaticBody

export  var MarkerPath : NodePath
#export  var PlayerPath : NodePath
export  var GridPath   : NodePath
export  var ArenaPath  : NodePath

onready var Marker = get_node(MarkerPath)
#onready var Player = get_node(PlayerPath)
onready var Grid   = get_node(GridPath)
onready var Arena  = get_node(ArenaPath)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input_event(camera, event, click_position, click_normal, shape_idx):
#	if event is InputEventMouseMotion:
#		print("Motion!" )
#		var mapPoint = Grid.world_to_map(click_position)
#		FightSystem.SelectedCharacter.draw_path(click_position)
#		print(str(mapPoint))
	if event is InputEventMouseButton && event.pressed:
		var startPosition = FightSystem.SelectedCharacter.ZonePosition
		var selectedPosition = Vector2(Grid.world_to_map(click_position).x, Grid.world_to_map(click_position).z)
		var trace = Arena.CheckTrace(FightSystem.SelectedCharacter, selectedPosition)
		var finalPath = Arena.SetGlobalPath(trace.path)
		FightSystem.SelectedCharacter.path = finalPath
#		print("Click!")
#		Marker.transform.origin = Vector3(click_position.x, Marker.transform.origin.y, click_position.z)
#		Marker.visible = true
#		
#		var mapPoint = Grid.world_to_map(click_position)
#		var newPathPoint = Grid.world_to_map(click_position) * Grid.cell_size + Grid.cell_size/2
#		newPathPoint.y = 1
#		if Arena.BelongingToZone(Vector2(mapPoint.x, mapPoint.z), FightSystem.SelectedCharacter.ZoneId):
#			print("Click and move!")
#			FightSystem.SelectedCharacter.move_to(Vector3(click_position.x, 0, click_position.z))
#			get_tree().call_group("Units", "move_to",  Vector3(click_position.x, 0, click_position.z))
#			Player.Trace.append(newPathPoint)
#
#		print(str(Grid.world_to_map(click_position)))
#		print(str(Grid.world_to_map(click_position) * Grid.cell_size + Grid.cell_size/2))
#		print(str(Grid.map_to_world(Grid.world_to_map(click_position).x, Grid.world_to_map(click_position).y, Grid.world_to_map(click_position).z)))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_StaticBody_input_event(camera, event, click_position, click_normal, shape_idx):
#	pass # Replace with function body.
