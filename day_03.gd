extends Node2D


func solve(input: String) -> void:
	print("asked to solve", input)
	var tot1 = 0
	var regex = RegEx.new()
	regex.compile("mul\\((\\d+),(\\d+)\\)")
	for mul in regex.search_all(input):
		tot1 += int(mul.get_string(1)) * int(mul.get_string(2))

	var tot2 = 0
	var regex2 = RegEx.new()
	regex2.compile("(mul\\((\\d+),(\\d+)\\))|(do\\(\\))|(don't\\(\\))")
	var enabled: bool = true
	for op in regex2.search_all(input):
		if op.get_string().contains("don't"):
			enabled = false
		elif op.get_string().contains("do()"):
			enabled = true
		else:
			if enabled:
				tot2 += int(op.get_string(2)) * int(op.get_string(3))

	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
