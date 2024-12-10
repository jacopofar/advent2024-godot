extends Node2D

func find_trail_ends(start: Vector2i, heights: Dictionary[Vector2i, int]) -> Dictionary[Vector2i, int]:
	var current_height = heights[start]
	var ret: Dictionary[Vector2i, int] = {}
	for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var next_one = start + dir
		if not heights.has(next_one):
			continue
		if current_height == 8 and heights[next_one] == 9:
			ret[next_one] = 1
			continue
		if heights[next_one] == current_height + 1:
			for e in find_trail_ends(next_one, heights):
				ret[e] = 1
	return ret

func count_trail_paths(start: Vector2i, heights: Dictionary[Vector2i, int]) -> int:
	var current_height = heights[start]
	var ret: int = 0
	for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var next_one = start + dir
		if not heights.has(next_one):
			continue
		if current_height == 8 and heights[next_one] == 9:
			ret += 1
			continue
		if heights[next_one] == current_height + 1:
			ret += count_trail_paths(next_one, heights)
	return ret


func solve(input: String) -> void:
	var rows = input.split("\n", false)
	var heights: Dictionary[Vector2i, int] = {}
	for ri in range(len(rows)):
		for ci in range(len(rows[0])):
			heights[Vector2i(ri, ci)] = int(rows[ri][ci])
	var tot1 = 0
	var tot2 = 0
	for p in heights.keys():
		if heights[p] != 0:
			continue
		print("found starting point ", p)
		var ends = find_trail_ends(p, heights)
		tot1 += ends.size()
		print("trail count: ", count_trail_paths(p, heights))
		tot2 += count_trail_paths(p, heights)
		
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
