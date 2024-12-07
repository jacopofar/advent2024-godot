extends Node2D

func vec2_to4(a: Vector2, b: Vector2) -> Vector4i:
	return Vector4i(a.x, a.y, b.x, b.y)

func vec4_to_pos(a: Vector4i) -> Vector2i:
	return Vector2i(a.x, a.y)

func unique_positions(pos_and_dirs: Dictionary[Vector4i, int]) -> Dictionary:
	var ret = Dictionary()
	for pos_and_dir in pos_and_dirs.keys():
		ret[vec4_to_pos(pos_and_dir)] = 1
	return ret

func is_loop(pos_and_dirs: Dictionary[Vector4i, int], limits: Rect2i) -> bool:
	for pos_and_dir in pos_and_dirs.keys():
		if not limits.has_point(vec4_to_pos(pos_and_dir)):
			return false
	return true 

func simulate_guard(obstacles: Dictionary[Vector2i, int], guard_position: Vector2i, guard_direction: Vector2i, limits: Rect2i) -> Dictionary[Vector4i, int]:
	var visited_positions: Dictionary = {vec2_to4(guard_position, guard_direction): 1}
	while limits.has_point(guard_position):
		var next_position = guard_position + guard_direction
		if obstacles.has(next_position):
			guard_direction = Vector2i(guard_direction.y, -guard_direction.x)
		else:
			guard_position = next_position
			if visited_positions.has(vec2_to4(guard_position, guard_direction)):
				# it's a loop
				break
			visited_positions[vec2_to4(guard_position, guard_direction)] = 1
	return visited_positions

func solve(input: String) -> void:
	var rows = input.split("\n", false)
	var obstacles: Dictionary[Vector2i, int] = {}
	var guard_position: Vector2i = Vector2i(-1, -1)
	var guard_direction: Vector2i = Vector2i(0, 0)
	var limits = Rect2i(0, 0, len(rows[0]), len(rows))
	for ri in range(len(rows)):
		for ci in range(len(rows[0])):
			if rows[ri][ci] == '#':
				obstacles[Vector2i(ri, ci)] = 1
			if rows[ri][ci] == '^':
				guard_direction = Vector2i(-1, 0)
				guard_position = Vector2i(ri, ci)
	assert (guard_position != Vector2i(-1, -1), "where is the guard??")
	var visited_positions_and_dirs = simulate_guard(obstacles, guard_position, guard_direction, limits)
	var visited_positions = unique_positions(visited_positions_and_dirs)
	
	# draw this!
	var scaling = min($Window.size.x / limits.size.x , $Window.size.y / limits.size.y)
	var padding = Vector2i(2, 2)
	for obs in obstacles.keys():
		var obs_r = ColorRect.new()
		obs_r.color = Color.BURLYWOOD
		obs_r.position = obs * scaling + padding
		obs_r.size = Vector2i(scaling, scaling) - padding * 2
		$Window.add_child(obs_r)
	for pos in visited_positions.keys():
		var pos_r = ColorRect.new()
		pos_r.color = Color.WHITE
		pos_r.position = pos * scaling + padding
		pos_r.size = Vector2i(scaling, scaling) - padding * 2
		$Window.add_child(pos_r)
	# remove 1 because the last one is outside the rect2
	var tot1 = visited_positions.size() - 1
	
	var tot2 = 0
	# for the part 2 we have to find an extra obstacle to create a loop
	# we know this is in the path, so let's brute force it
	var original_obstacles = obstacles.duplicate()
	for pos in visited_positions:
		print("inspecting ", pos)
		# the problem asks to ignore the cell in front of th guard
		if pos == guard_position + guard_direction:
			continue
		obstacles[pos] = 1
		visited_positions_and_dirs = simulate_guard(obstacles, guard_position, guard_direction, limits)
		if is_loop(visited_positions_and_dirs, limits):
			print("found one at ", pos)
			# mark it
			var pos_r = ColorRect.new()
			pos_r.color = Color.ORANGE_RED
			pos_r.position = pos * scaling + padding
			pos_r.size = Vector2i(scaling, scaling) - padding * 2
			$Window.add_child(pos_r)
			tot2 += 1
		else:
			print("no loop crated by ", pos)
		obstacles = original_obstacles.duplicate()
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))


func _on_window_close_requested() -> void:
	$Window.hide()
