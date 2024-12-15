extends Window

var directions: Dictionary[String, Vector2i] = {
	"<": Vector2i(-1, 0),
	">": Vector2i(1, 0),
	"^": Vector2i(0, -1),
	"v": Vector2i(0, 1),
}

func move_robot(dir_str: String, robot_pos: Vector2i, obstacles: Dictionary[Vector2i, int], walls: Dictionary[Vector2i, int]) -> Array:
	var dir: Vector2i = directions[dir_str]
	var effect = 1
	var shifts: Dictionary[Vector2i, Vector2i] = {}
	while true:
		var check_pos = robot_pos + effect * dir
		if walls.has(check_pos):
			# we found a wall, nothing to move
			return [robot_pos, {}]
		elif obstacles.has(check_pos):
			# we found a candidate obstacle to move
			shifts[check_pos] = check_pos + dir
		else:
			# no walls not obstacles, it was free
			return [robot_pos + dir, shifts]
		# keep searching
		effect += 1
	# this should never happen!
	push_error("??? this move is impossible")
	return []

func solve(input: String) -> void:
	var rows = input.split("\n", true)
	var obstacles: Dictionary[Vector2i, int] = {}
	var walls: Dictionary[Vector2i, int] = {}
	var robot_pos: Vector2i = Vector2i(0, 0)

	for ri in range(len(rows)):
		if rows[ri] == "":
			break
		for ci in range(len(rows[0])):
			if rows[ri][ci] == "#":
				walls[Vector2i(ci, ri)] = 1
			elif rows[ri][ci] == "O":
				obstacles[Vector2i(ci, ri)] = 1
			elif rows[ri][ci] == "@":
				robot_pos = Vector2i(ci, ri)
	var all_moves: String = input.split("\n\n")[1].replace("\n", "")
	var tot1 = 0
	var tot2 = -1
	for move in all_moves:
		var update = move_robot(move, robot_pos, obstacles, walls)
		robot_pos = update[0]
		for oo in update[1].keys():
			obstacles.erase(oo)
		for on in update[1].values():
			obstacles[on] = 1
	for o in obstacles.keys():
		tot1 += o.y * 100 + o.x
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))

func _on_window_close_requested() -> void:
	hide()
