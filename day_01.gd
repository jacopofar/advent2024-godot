extends Node2D

func solve(input: String) -> void:
	print("asked to solve", input)
	# split input in lines, convert them to int
	var numbers_a: PackedInt32Array = []
	var numbers_b: PackedInt32Array = []
	
	for line in input.split("\n"):
		if line == "":
			continue
		var parts = line.split("   ", false)
		numbers_a.append(int(parts[0]))
		numbers_b.append(int(parts[1]))

	numbers_a.sort()
	numbers_b.sort()
	
	var tot: int = 0
	for n in range(len(numbers_a)):
		tot += abs(numbers_a[n] - numbers_b[n])
	### part 2
	var count_a:Dictionary = {}
	var count_b:Dictionary = {}
	for n in range(len(numbers_a)):
		count_a[numbers_a[n]] = count_a.get_or_add(numbers_a[n], 0) + 1
		count_b[numbers_b[n]] = count_b.get_or_add(numbers_b[n], 0) + 1
	var tot2: int = 0
	for k in count_a.keys():
		tot2 += k * count_b.get(k, 0)
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot, tot2]))
	
