extends Node2D

func expand_to_region(garden: Dictionary[Vector2i, String], start: Vector2i) -> Dictionary[Vector2i, int]:
	var ret: Dictionary[Vector2i, int] = {start: 1}
	var border: Dictionary[Vector2i, int] = {start: 1}
	while len(border) > 0:
		var new_border: Dictionary[Vector2i, int] = {}
		for c in border.keys():
			for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var candidate = c + dir
				# same plant type, or even non existant?
				if garden.get(candidate) != garden[c]:
					continue
				# already explored
				if ret.has(candidate):
					continue
				# valid
				ret[candidate] = 1
				new_border[candidate] = 1
		border = new_border
	return ret

func get_region(labeled: Dictionary[Vector2i, int], idx: int) -> Dictionary[Vector2i, int]:
	var ret: Dictionary[Vector2i, int] = {}
	for k in labeled.keys():
		if labeled[k] == idx:
			ret[k] = 1
	return ret

func get_perimeter(single_region: Dictionary[Vector2i, int]) -> int:
	var ret = 0
	for c in single_region.keys():
		# basically every side of a cell that s not touching another cell of this region
		# contributes 1 to the primeter
		for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			if not single_region.has(c + dir):
				ret += 1
	return ret

func get_topo_perimeter(single_region: Dictionary[Vector2i, int]) -> int:
	# basically counts the corners, not the sides
	var ret = 0
	for c in single_region.keys():
		# imagine being in a cell and looking in this direction, is it empty and there's also empty on your left?
		# then the cell corner between the front and the left is a shape corner
		# left or right does not matter, as long as it's always the same to avoid double counting
		for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var left_dir = Vector2i(-dir.y, dir.x)
			# is it empty in front of me?
			var empty_front = (not single_region.has(c + dir))
			# is it empty on my left?
			var empty_left = (not single_region.has(c + left_dir))
			# what about the diagonal?
			var empty_diag = (not single_region.has(c + left_dir + dir))
			# a shape corner is when front and left are identical and opposite to the diagonal
			# note there's a special case when the diagonal is full but the sids ar empty, the shape is "pinching" itself
			if empty_front == empty_left and (empty_diag or empty_front):
				ret += 1
	return ret


func label_regions(garden: Dictionary[Vector2i, String]) -> Dictionary[Vector2i, int]:
	var ret: Dictionary[Vector2i, int] = {}
	var idx = 0
	for candidate_region in garden.keys():
		if ret.has(candidate_region):
			continue
		var new_region = expand_to_region(garden, candidate_region)
		for nr in new_region.keys():
			ret[nr] = idx
		idx += 1
	return ret

func solve(input: String) -> void:
	var garden: Dictionary[Vector2i, String] = {}
	var rows = input.split("\n", false)

	for ri in range(len(rows)):
		for ci in range(len(rows[0])):
			garden[Vector2i(ri, ci)] = rows[ri][ci]
	var labeled = label_regions(garden)
	var tot1 = 0
	var tot2 = 0
	for idx in range(labeled.values().max() + 1):
		var this_region = get_region(labeled, idx)
		tot1 += get_perimeter(this_region) * this_region.size()
		tot2 += get_topo_perimeter(this_region) * this_region.size()
		
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
