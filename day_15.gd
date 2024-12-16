extends Window

var directions: Dictionary[String, Vector2i] = {
	"<": Vector2i(-1, 0),
	">": Vector2i(1, 0),
	"^": Vector2i(0, -1),
	"v": Vector2i(0, 1),
}

func move_robot(dir_str: String, robot_pos: Vector2i, obstacles: Dictionary[Vector2i, int], walls: Dictionary[Vector2i, int],  obstacles_ends: Dictionary[Vector2i, int] = {}) -> Array:
	var dir: Vector2i = directions[dir_str]
	var check_pos = robot_pos + dir
	if walls.has(check_pos):
		# we found a wall, nothing to move
		return [robot_pos, {}]
	elif obstacles.has(check_pos) or obstacles_ends.has(check_pos):
		# we found a candidate obstacle to move
		var effects = what_gets_moved(check_pos, dir, obstacles, walls, obstacles_ends)
		if effects[0]:
			return [robot_pos + dir, effects[1]]
		else:
			# it cannot move the obstacles
			return [robot_pos, {}]
	else:
		# no walls not obstacles, it was free
		return [robot_pos + dir, {}]

# given a coordinate of what to move and the direction, return an array
# the first element is true if the movement is possible, false otherwise
# the second element is the dictionary of from -> to coordinates
func what_gets_moved(what_moves: Vector2i, dir: Vector2i, obstacles: Dictionary[Vector2i, int], walls: Dictionary[Vector2i, int], obstacles_ends: Dictionary[Vector2i, int]) -> Array:
	if not obstacles.merged(obstacles_ends).has(what_moves):
		# "fake" move, nothing is being moved
		return [true, {}]
	var new_pos = what_moves + dir
	var other_half_new_pos = (new_pos + Vector2i(1, 0)) if obstacles.has(what_moves) else (new_pos - Vector2i(1, 0))
	if len(obstacles_ends) == 0 or dir.y == 0:
		other_half_new_pos = new_pos
	# this cannot move, fail
	if walls.has(new_pos) or walls.has(other_half_new_pos):
		return [false, {}]
	# candidate shifts for this pair
	var shifts: Dictionary[Vector2i, Vector2i] = {}
	shifts[new_pos - dir] = new_pos
	shifts[other_half_new_pos - dir] = other_half_new_pos
	# can both move freely? report it
	if (not obstacles.merged(obstacles_ends).has(new_pos)) and (not obstacles.merged(obstacles_ends).has(other_half_new_pos)):
		return [true, shifts]
	#try to move them both
	var next_one_a = what_gets_moved(new_pos, dir, obstacles, walls, obstacles_ends)
	if not next_one_a[0]:
		return [false, {}]
	var next_one_b = what_gets_moved(other_half_new_pos, dir, obstacles, walls, obstacles_ends)
	if not next_one_b[0]:
		return [false, {}]
	# they can, merge the shifts
	shifts.merge(next_one_a[1])
	shifts.merge(next_one_b[1])
	return [true, shifts]
	
			

func score(obstacles: Dictionary[Vector2i, int]) -> int:
	var ret = 0
	for o in obstacles.keys():
		ret += o.y * 100 + o.x
	return ret

func parse_map(raw_map: String) -> Array:
	var obstacles: Dictionary[Vector2i, int] = {}
	var obstacles_ends: Dictionary[Vector2i, int] = {}
	var walls: Dictionary[Vector2i, int] = {}
	var robot_pos: Vector2i = Vector2i(0, 0)
	var rows = raw_map.split("\n")
	for ri in range(len(rows)):
		for ci in range(len(rows[0])):
			if rows[ri][ci] == "#":
				walls[Vector2i(ci, ri)] = 1
			elif rows[ri][ci] == "O":
				obstacles[Vector2i(ci, ri)] = 1
			elif rows[ri][ci] == "@":
				robot_pos = Vector2i(ci, ri)
			elif rows[ri][ci] == "[":
				obstacles[Vector2i(ci, ri)] = 1
			elif rows[ri][ci] == "]":
				obstacles_ends[Vector2i(ci, ri)] = 1
	return [walls, obstacles, robot_pos, obstacles_ends]

func append_log(s: String):
	print(s)
	#var file = FileAccess.open("/tmp/log.log", FileAccess.READ)
	#var msg = file.get_as_text() + "\n" + s
	#file = FileAccess.open("/tmp/log.log", FileAccess.WRITE)
	#file.store_string(msg)
	#file.close()

func print_situa(walls, robot_pos, obstacles, obstacles_ends) -> void:
	return
	for ri in range(10):
		var line = ""
		for ci in range(21):
			var cell = Vector2i(ci, ri)
			if walls.has(cell):
				line += "#"
			elif robot_pos == cell:
				line += "@"
			elif obstacles.has(cell):
				line += "["
			elif obstacles_ends.has(cell):
				line += "]"
			else:
				line += "."
		append_log(line)

func solve(input: String) -> void:
	var obstacles: Dictionary[Vector2i, int] = {}
	var walls: Dictionary[Vector2i, int] = {}
	var robot_pos: Vector2i = Vector2i(0, 0)
	
	var input_parts = input.split("\n\n")
	
	var parsed = parse_map(input_parts[0])
	walls = parsed[0]
	obstacles = parsed[1]
	robot_pos = parsed[2]
	
	var all_moves: String = input_parts[1].replace("\n", "")
	for move in all_moves:
		var update = move_robot(move, robot_pos, obstacles, walls)
		robot_pos = update[0]
		for oo in update[1].keys():
			obstacles.erase(oo)
		for on in update[1].values():
			obstacles[on] = 1
	var tot1 = score(obstacles)
	
	# now for part 2 everything is doubled, and obstacles are always of size 2
	var doubled_map = input_parts[0].replace("#", "##").replace("O", "[]").replace(".", "..").replace("@", "@.")
	append_log(doubled_map)
	parsed = parse_map(doubled_map)
	walls = parsed[0]
	obstacles = parsed[1]
	robot_pos = parsed[2]
	var obstacles_ends = parsed[3]
	append_log("START HERE")
	print_situa(walls, robot_pos, obstacles, obstacles_ends)
	for movei in range(len(all_moves)):
		var move = all_moves[movei]
		append_log("---")
		append_log(str(movei) + " is " + move)
		if movei == 450:
			print(7)
		var update = move_robot(move, robot_pos, obstacles, walls, obstacles_ends)
		append_log("news: " + str(update))
		robot_pos = update[0]
		# get shifts only for th ends
		var shift_ends = {}
		var shift_starts = {}
		for oo in update[1].keys():
			if obstacles_ends.has(oo):
				shift_ends[oo] = update[1][oo]
			else:
				shift_starts[oo] = update[1][oo]
				
		# move the start(left) parts
		for oo in shift_starts.keys():
			obstacles.erase(oo)
		for on in shift_starts.values():
			obstacles[on] = 1
		# now the ends
		for oo in shift_ends.keys():
			obstacles_ends.erase(oo)
		for on in shift_ends.values():
			obstacles_ends[on] = 1
		print_situa(walls, robot_pos, obstacles, obstacles_ends)

		
	var tot2 = score(obstacles)

	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))

func _on_window_close_requested() -> void:
	hide()
