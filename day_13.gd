extends Node2D

func best_presses(bax: float, bay: float, bbx: float, bby: float, px: float, py: float) -> Array:
	var press_b = (bay * px - py * bax) / (bay * bbx - bby * bax)
	var press_a = (px - press_b * bbx) / bax
	return [press_a, press_b]

func solve(input: String) -> void:
	var claw_machines = []
	var new_machine = []
	var regex_two_nums = RegEx.new()
	regex_two_nums.compile(r"[^0-9]+(\d+)[^0-9]+(\d+)")
	for row in input.split("\n", false):
		if row.find("Button A:") == 0 and len(new_machine) == 0:
			var matches = regex_two_nums.search(row)
			new_machine.append(int(matches.get_string(1)))
			new_machine.append(int(matches.get_string(2)))
		elif row.find("Button B:") == 0 and len(new_machine) == 2:
			var matches = regex_two_nums.search(row)
			new_machine.append(int(matches.get_string(1)))
			new_machine.append(int(matches.get_string(2)))
		elif row.find("Prize:") == 0 and len(new_machine) == 4:
			var matches = regex_two_nums.search(row)
			new_machine.append(int(matches.get_string(1)))
			new_machine.append(int(matches.get_string(2)))
			claw_machines.append(new_machine)
			new_machine = []
		else:
			assert(false, "Something wrong with the input: " + row)
	var tot1 = 0
	
	for cm in claw_machines:
		var bax = cm[0]
		var bay = cm[1]
		var bbx = cm[2]
		var bby = cm[3]
		var px = cm[4]
		var py = cm[5]
		
		var possible_win = best_presses(bax, bay, bbx, bby, px, py)
		if possible_win[0] > 100 or possible_win[1] > 100:
			continue
		if possible_win[0] < 0 or possible_win[1] < 0:
			continue
		# non integer solutions!
		if possible_win[0] != int(possible_win[0]):
			continue
		if possible_win[1] != int(possible_win[1]):
			continue
		tot1 += possible_win[0] * 3 + possible_win[1]
	# copy paste because I'm lazy!
	var tot2 = 0
	for cm in claw_machines:
		var bax = cm[0]
		var bay = cm[1]
		var bbx = cm[2]
		var bby = cm[3]
		var px = cm[4]
		var py = cm[5]
		px += 10000000000000
		py += 10000000000000
		
		var possible_win = best_presses(bax, bay, bbx, bby, px, py)
		if possible_win[0] < 0 or possible_win[1] < 0:
			continue
		# non integer solutions!
		if possible_win[0] != int(possible_win[0]):
			continue
		if possible_win[1] != int(possible_win[1]):
			continue
		tot2 += possible_win[0] * 3 + possible_win[1]
		
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
