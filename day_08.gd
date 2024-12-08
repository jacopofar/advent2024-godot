extends Node2D

func get_antinodes(antennas: Array, limits: Rect2i, accept_multiples: bool = false) -> Dictionary[Vector2i, int]:
	var ret: Dictionary[Vector2i, int] = {}
	var multiplicators = [1]
	if accept_multiples:
		multiplicators = range(max(limits.size.x, limits.size.y))
	for ai in range(len(antennas)):
		for bi in range(ai + 1, len(antennas)):
			var a: Vector2i = antennas[ai]
			var b: Vector2i = antennas[bi]
			for mul in multiplicators:
				var candidate_antinode = b + (b - a) * mul
				if limits.has_point(candidate_antinode):
					ret[candidate_antinode] = 1
				candidate_antinode = a + (a - b) * mul
				if limits.has_point(candidate_antinode):
					ret[candidate_antinode] = 1
	return ret

func solve(input: String) -> void:
	var rows = input.split("\n", false)
	var limits = Rect2i(0, 0, len(rows[0]), len(rows))
	var antennas_by_type: Dictionary[String, Array] = {}
	var all_antennas: Dictionary[Vector2i, int] = {}
	for ri in range(len(rows)):
		for ci in range(len(rows[0])):
			if rows[ri][ci] == '.':
				continue
			all_antennas[Vector2i(ri, ci)] = 1
			if antennas_by_type.has(rows[ri][ci]):
				antennas_by_type[rows[ri][ci]].append(Vector2i(ri, ci))
			else:
				antennas_by_type[rows[ri][ci]] = [Vector2i(ri, ci)]
	
	var valid_antinodes: Dictionary[Vector2i, int] = {}
	for antenna_type in antennas_by_type.keys():
		var these_antennas: Array = antennas_by_type[antenna_type]
		for antinode in get_antinodes(these_antennas, limits).keys():
			#if all_antennas.has(antinode):
				#continue
			valid_antinodes[antinode] = 1
	var tot1 = valid_antinodes.size()
	# part 2, the same but with multiples
	valid_antinodes = {}
	for antenna_type in antennas_by_type.keys():
		var these_antennas: Array = antennas_by_type[antenna_type]
		for antinode in get_antinodes(these_antennas, limits, true).keys():
			#if all_antennas.has(antinode):
				#continue
			valid_antinodes[antinode] = 1
	var tot2 = valid_antinodes.size()
	
	# draw this!
	var scaling = min($Window.size.x / limits.size.x , $Window.size.y / limits.size.y)
	var padding = Vector2i(2, 2)
	# draw the antinodes
	for ano_orig in valid_antinodes.keys():
		var ano = Vector2i(ano_orig.y, ano_orig.x)
		var obs_r = ColorRect.new()
		obs_r.color = Color(1.0, 1.0, 1.0, 0.8)
		obs_r.position = ano * scaling + padding
		obs_r.size = Vector2i(scaling, scaling) - padding * 2
		$Window.add_child(obs_r)
	# draw the antennas
	for antenna_type in antennas_by_type.keys():
		for ant_orig in antennas_by_type[antenna_type]:
			var ant = Vector2i(ant_orig.y, ant_orig.x)
			var ant_r = ColorRect.new()
			ant_r.color = Color(1.0, 0.0, 0.0, 0.8)
			# more padding to not hide antinodes
			ant_r.position = ant * scaling + padding * 3
			ant_r.size = Vector2i(scaling, scaling) - padding * 6
			$Window.add_child(ant_r)
	
		
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))


func _on_window_close_requested() -> void:
	$Window.hide()
