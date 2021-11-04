extends Node

var astar : AStar
func _init_astar(grid_map : GridMap, cells):
	astar = AStar.new()
	cells.sort()
	for i in range(cells.size()):
		var cell = cells[i]
		astar.add_point(i, grid_map.map_to_world(cell.x, cell.y, cell.z))
		var neighbours = [
			Vector3(cell.x, cell.y, cell.z - 1),
			Vector3(cell.x - 1, cell.y, cell.z),
		]
		for neighbour in neighbours:
			if cells[0].x > neighbour.x || cells[0].y > neighbour.y:
				continue
			astar.connect_points(i, astar.get_closest_point(grid_map.map_to_world(neighbour.x, neighbour.y, neighbour.z)))
			pass
	pass
