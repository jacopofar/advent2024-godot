extends Node2D

func blink(stones: Array[int]) -> Array[int]:
	var ret: Array[int] = []
	for s in stones:
		if s == 0:
			ret.append(1)
		elif len(str(s)) % 2 == 0:
			ret.append(int(str(s).left(len(str(s))/2)))
			ret.append(int(str(s).right(len(str(s))/2)))
		else:
			ret.append(s * 2024)
	return ret

func count_stone_size_after_steps(stone: int, steps: int) -> int:
	print("asked to get length of ", stone, " offspring after ", steps)
	if steps == 0:
		return 1
	if stone == 0:
		return(count_stone_size_after_steps(1, steps - 1))
	elif len(str(stone)) % 2 == 0:
		return (
			count_stone_size_after_steps(int(str(stone).left(len(str(stone))/2)), steps - 1)
			+ count_stone_size_after_steps(int(str(stone).right(len(str(stone))/2)), steps - 1)
		)
	else:
		return count_stone_size_after_steps(stone * 2024, steps - 1)

func solve(input: String) -> void:
	var stones: Array[int] = []
	for s in input.split(" ", false):
		stones.append(int(s))
	var stones_state = stones.duplicate()
	var STEPS = 25
	print(stones_state)
	for i in range(STEPS):
		stones_state = blink(stones_state)
		print(stones_state)
	var tot1 = len(stones_state)
	var tot2 = 0
	for s in stones:
		tot2 += count_stone_size_after_steps(s, STEPS)
	get_parent().set_solution("Part 1: {0} part 2: {1}".format([tot1, tot2]))
