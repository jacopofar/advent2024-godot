extends Node2D

func is_solvable(eq: PackedInt64Array, with_concatenation: bool = false) -> bool:
	# no operations left, stop
	#print("receive ", eq)
	if len(eq) == 2:
		return eq[0] == eq[1]
	# alrady too much, stop earlier
	if eq[0] < eq[1]:
		return false
	# try both possibilities recursively
	#print("try +")
	var eq2 = eq.duplicate()
	eq2[1] = eq2[1] + eq2[2]
	eq2.remove_at(2)
	if is_solvable(eq2, with_concatenation):
		return true
	#print("try *")

	eq2 = eq.duplicate()
	eq2[1] = eq2[1] * eq2[2]
	eq2.remove_at(2)
	if is_solvable(eq2, with_concatenation):
		return true
	
	if with_concatenation:
		#print("try ||")
		
		eq2 = eq.duplicate()
		eq2[1] = int(str(eq2[1]) + str(eq2[2]))
		eq2.remove_at(2)
		if is_solvable(eq2, with_concatenation):
			return true
	return false

func solve(input: String) -> void:
	var eqs: Array[PackedInt64Array] = []
	for line in input.split("\n"):
		if line == "":
			continue
		var eq = PackedInt64Array([int(line.split(":")[0])])
		for n in line.split(":")[1].split(" ", false):
			eq.append(int(n))
		eqs.append(eq)
	var tot1 = 0
	for eq in eqs:
		if is_solvable(eq):
			tot1 += eq[0]
	var tot2 = 0
	for eq in eqs:
		if is_solvable(eq, true):
			tot2 += eq[0]
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
