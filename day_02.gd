extends Node2D

func is_safe(report: PackedByteArray) -> bool:
	var slope: int = sign(report[1] - report[0])
	if slope == 0:
		return false
	for i in range(1, len(report)):
		var diff: int = report[i] - report[i - 1]
		if sign(diff) != slope:
			return false
		if abs(diff) > 3:
			return false
	return true

func safe_by_maybe_removing_one(report: PackedByteArray) -> bool:
	# simply tries to remove 1 (but not more) element and check if is_safe is satisfied then
	if is_safe(report):
		return true
	for i in range(len(report)):
		var dampened = report.slice(0, i) + report.slice(i + 1, len(report))
		if is_safe(dampened):
			return true
	return false

func solve(input: String) -> void:
	print("asked to solve", input)
	# split input in lines, convert them to int
	var numbers = []
	var total_safe:int = 0
	var total_safe_part2:int = 0
	
	for line in input.split("\n"):
		if line == "":
			continue
		var parts = line.split(" ", false)
		var report: PackedByteArray = []
		for p in parts:
			report.append(int(p))
		numbers.append(report)
		if is_safe(report):
			total_safe += 1
		if safe_by_maybe_removing_one(report):
			total_safe_part2 += 1
	print(numbers)
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([total_safe, total_safe_part2]))
