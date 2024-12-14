extends Window

func position_after_steps(pos: Array, speed: Array, steps: int, max_x: int, max_y: int) -> Array:
	var final_pos = [pos[0] + steps * speed[0], pos[1] + steps * speed[1]]
	final_pos[0] = final_pos[0] % max_x
	final_pos[1] = final_pos[1] % max_y
	if final_pos[0] < 0:
		final_pos[0] = max_x + final_pos[0]
	if final_pos[1] < 0:
		final_pos[1] = max_y + final_pos[1]
	return final_pos
	
func solve(input: String) -> void:
	var tot1 = 0
	var tot2 = 0
	var regex_four_nums = RegEx.new()
	regex_four_nums.compile(r"[^-0-9]+(-?\d+)[^-0-9]+(-?\d+)[^-0-9]+(-?\d+)[^-0-9]+(-?\d+)")
	var positions: Array[Array] = []
	var speeds: Array[Array] = []
	for row in input.split("\n", false):
		var matches = regex_four_nums.search(row)
		#print(matches.get_string(1), " ", matches.get_string(2), " ", matches.get_string(3), " ", matches.get_string(4))
		positions.append([int(matches.get_string(1)), int(matches.get_string(2))])
		speeds.append([int(matches.get_string(3)), int(matches.get_string(4))])
	var MAX_X = 101
	var MAX_Y = 103
	var quadrants_count = [0, 0,  0,  0]
	for ri in range(len(positions)):
		var final_pos = position_after_steps(positions[ri], speeds[ri], 100, MAX_X, MAX_Y)
		# ignore robots in the quadrant borders
		if final_pos[0] == (MAX_X - 1) / 2:
			continue
		if final_pos[1] == (MAX_Y - 1) / 2:
			continue
		var qx = 1 if ((MAX_X - 1) / 2 > final_pos[0]) else 0
		var qy = 1 if ((MAX_Y - 1) / 2 > final_pos[1]) else 0
		quadrants_count[qx * 2 + qy] += 1
	tot1 = quadrants_count[0] * quadrants_count[1] * quadrants_count[2] * quadrants_count[3]
	# part 2 is totally different, we want to iterate over the steps!
	var steps_states = []
	for si in range(10000):
		var step_state = []
		for ri in range(len(positions)):
			var final_pos = position_after_steps(positions[ri], speeds[ri], si, MAX_X, MAX_Y)
			step_state.append(final_pos)
		steps_states.append(step_state)
	$Canvas.set_state_story(steps_states)
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))

func _on_window_close_requested() -> void:
	hide()
	$Canvas/Timer.stop()
