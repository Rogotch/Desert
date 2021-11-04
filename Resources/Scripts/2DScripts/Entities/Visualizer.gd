extends Node2D

export var CellScale : float
export var CellImage : Texture
export var GridPath : NodePath
onready var Grid = get_node(GridPath)
onready var CellClass = preload("res://Resources/Entities/2D/Cell.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(Grid.grid_size.x):
		for y in Grid.grid_size.y:
			var Cell = CellClass.instance()
			add_child(Cell)
			Cell.texture = (CellImage)
			Cell.scale = Vector2(CellScale, CellScale)
			Cell.position = Grid.map_to_world(Vector2(x,y)) + Grid.half_tile_size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
