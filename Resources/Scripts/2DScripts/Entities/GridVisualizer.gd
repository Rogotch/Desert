extends Node2D

onready var grid = get_parent()
export var LINE_COLOR : Color
export var LINE_WIDTH : int

func _ready():
#	modulate = Color( 1, 0.2, 0, 0.2 )
	pass

func _draw():
#	var window_size = OS.get_window_size()
#	for x in range(grid.cell_quadrant_size + 1):
#		var col_pos = x * grid.cell_size.x
#		var limit = grid.grid_size.y * grid.cell_size.y
#		draw_line(Vector2(col_pos, 0), Vector2(col_pos, limit), LINE_COLOR, LINE_WIDTH)
#	for y in range(grid.cell_quadrant_size + 1):
#		var row_pos = y * grid.cell_size.y
#		var limit = grid.grid_size.x * grid.cell_size.x
#		draw_line(Vector2(0, row_pos), Vector2(limit, row_pos), LINE_COLOR, LINE_WIDTH)
	for x in range(grid.grid_size.x):
		for y in grid.grid_size.y:
			draw_line(Vector2(grid.tile_size.x * x, grid.tile_size.y * y), Vector2(grid.tile_size.x * (x + 1), grid.tile_size.y * (y)), LINE_COLOR, LINE_WIDTH)
			draw_line(Vector2(grid.tile_size.x * x, grid.tile_size.y * y), Vector2(grid.tile_size.x * (x), grid.tile_size.y * (y + 1)), LINE_COLOR, LINE_WIDTH)
			draw_line(Vector2(grid.tile_size.x * x, grid.tile_size.y * (y + 1)), Vector2(grid.tile_size.x * (x + 1), grid.tile_size.y * (y + 1)), LINE_COLOR, LINE_WIDTH)
			draw_line(Vector2(grid.tile_size.x * (x + 1), grid.tile_size.y * y), Vector2(grid.tile_size.x * (x + 1), grid.tile_size.y * (y + 1)), LINE_COLOR, LINE_WIDTH)
			
	pass
